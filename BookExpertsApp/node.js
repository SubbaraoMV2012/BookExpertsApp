const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendDeleteNotification = functions.https.onCall(async (data, context) => {
    const { itemName, itemId, fcmToken } = data;

    const message = {
        token: fcmToken,
        notification: {
            title: "Item Deleted",
            body: `Deleted item: ${itemName} (ID: ${itemId})`
        }
    };

    try {
        await admin.messaging().send(message);
        return { success: true };
    } catch (error) {
        console.error("Error sending message:", error);
        throw new functions.https.HttpsError("internal", "Failed to send notification");
    }
});
