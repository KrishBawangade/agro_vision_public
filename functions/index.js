const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const { GoogleGenAI } = require("@google/genai");

// Access the API key from Firebase environment configuration
const apiKey = process.env.GEMINI_API_KEY || require("firebase-functions").config().gemini.key;

const genAI = new GoogleGenAI({ apiKey });

exports.generateGeminiChatResponse = onRequest(async (req, res) => {
  const { chats, maxConversations = 5 } = req.body;

  if (!chats || !Array.isArray(chats) || chats.length < 2) {
    return res.status(400).json({ error: "Invalid chat list. Must include at least system and one user message." });
  }

  try {
    // Extract system instruction from first message
    const systemInstruction = chats[0].parts?.[0]?.text || "";

    // Remaining chats used as history (excluding the last message)
    const historyChats = chats.slice(1, chats.length - 1);
    const historyLength = Math.min(historyChats.length, maxConversations);
    const history = historyChats.slice(0, historyLength);

    // Create the chat instance with system instruction
    const chat = genAI.chats.create({
      model: "gemini-2.0-flash",
      config: {  
        systemInstruction: systemInstruction,
        tools: [{googleSearch: {}}]
      },
      history,
    });

    // Last chat is the new user message to send
    const userMessage = chats[chats.length - 1].parts[0].text;
    const response = await chat.sendMessage({
      message: userMessage});

    res.json({ output: response.text });
  } catch (error) {
    logger.error("Gemini SDK error:", error);
    res.status(500).json({ error: "Gemini SDK failed", details: error.message });
  }
});
