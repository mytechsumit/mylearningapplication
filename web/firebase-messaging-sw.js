importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

// तुमच्या Firebase Console मधील Web App Configuration च्या व्हॅल्यूज इथे टाका
firebase.initializeApp({
  apiKey: "AIzaSyDppOqoi4nk34MK7PlxAojMEYuRjPLyBYk",
  authDomain: "myflutterlearningproject.firebaseapp.com",
  projectId: "myflutterlearningproject",
  storageBucket: "myflutterlearningproject.firebasestorage.app",
  messagingSenderId: "267388579884",
  appId: "1:267388579884:web:b15af502b4d33cf7dc6189"
});

const messaging = firebase.messaging();

// बॅकग्राउंड नोटिफिकेशन हँडल करण्यासाठी
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png' // ऐच्छिक: तुमच्या लोगोचा पाथ
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});