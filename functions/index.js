const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

/////////////////////////
// 1. User Info Update
/////////////////////////

exports.syncUserUpdates = functions.firestore
  .document("users/{userId}")
  .onUpdate(async (change, context) => {
    const userId = context.params.userId;
    const newData = change.after.data();
    const updates = {
      userName: newData.name,
      userProfileImage: newData.profileImage,
      userNativeLanguage: newData.nativeLanguage,
      userTargetLanguage: newData.targetLanguage,
      userDistrict: newData.district,
      userLocation: newData.location,
      userBio: newData.bio,
      userBirthdate: newData.birthdate,
      userHobbies: newData.hobbies,
      userLanguageLearningGoal: newData.languageLearningGoal,
    };

    // Update posts
    const postsSnapshot = await db.collection("posts").where("uid", "==", userId).get();
    const postUpdates = postsSnapshot.docs.map(doc => doc.ref.update(updates));

    // Update comments
    const postsWithComments = await db.collection("posts").get();
    const commentUpdates = [];

    for (const postDoc of postsWithComments.docs) {
      const commentsSnapshot = await postDoc.ref.collection("comments").where("uid", "==", userId).get();
      commentsSnapshot.forEach(commentDoc => {
        commentUpdates.push(commentDoc.ref.update({
          userName: newData.name,
          userProfileImage: newData.profileImage
        }));
      });
    }

    return Promise.all([...postUpdates, ...commentUpdates]);
  });

/////////////////////////
// 2. User Deletion Cleanup
/////////////////////////

exports.cleanupUserData = functions.firestore
  .document("users/{userId}")
  .onDelete(async (snap, context) => {
    const userId = context.params.userId;

    // Delete user's posts
    const postsSnapshot = await db.collection("posts").where("uid", "==", userId).get();
    const deletePosts = postsSnapshot.docs.map(doc => doc.ref.delete());

    // Delete user's comments
    const postsWithComments = await db.collection("posts").get();
    const deleteComments = [];

    for (const postDoc of postsWithComments.docs) {
      const commentsSnapshot = await postDoc.ref.collection("comments").where("uid", "==", userId).get();
      commentsSnapshot.forEach(commentDoc => {
        deleteComments.push(commentDoc.ref.delete());
      });
    }

    // TODO: Best practice is to anonymize comments instead of deleting
    // TODO: Also consider deleting likes (not critical now)

    return Promise.all([...deletePosts, ...deleteComments]);
  });

/////////////////////////
// 3. Post Deletion Cleanup
/////////////////////////

exports.cleanupPostSubcollections = functions.firestore
  .document("posts/{postId}")
  .onDelete(async (snap, context) => {
    const postId = context.params.postId;
    const postRef = db.collection("posts").doc(postId);

    // Delete comments
    const commentsSnapshot = await postRef.collection("comments").get();
    const deleteComments = commentsSnapshot.docs.map(doc => doc.ref.delete());

    // TODO: Could also delete likes if needed

    return Promise.all(deleteComments);
  });

/////////////////////////
// 5. Report Created Notification
/////////////////////////

//exports.notifyAdminOnReport = functions.firestore
//  .document("reports/{reportId}")
//  .onCreate(async (snap, context) => {
//    const report = snap.data();
//
//    const mailOptions = {
//      from: `"ShareLingo Reports" <noreply@firebase.com>`,
//      to: "penjan.eng@gmail.com",
//      subject: `🚨 New Report Submitted`,
//      text: `
//        A new report was submitted:
//
//        Reporter: ${report.reporterName}
//        Post ID: ${report.postId}
//        Reason: ${report.reason}
//        Description: ${report.description}
//      `
//    };
//
//    // Setup nodemailer using Gmail
//    const nodemailer = require("nodemailer");
//    const transporter = nodemailer.createTransport({
//      service: "gmail",
//      auth: {
//        user: "penjan.eng@gmail.com",
//        pass: ""
//      }
//    });
//
//    try {
//      await transporter.sendMail(mailOptions);
//      console.log("Report notification email sent.");
//    } catch (err) {
//      console.error("Error sending email:", err);
//    }
//
//    return null;
//  });
