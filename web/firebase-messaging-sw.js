// web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

// Ganti ini dengan konfigurasi Firebase project kamu
firebase.initializeApp({
  apiKey: 'AIzaSyAh2dJMBB8a6LI6-x08e-zCX4FsUESBiwY',
  appId: '1:408681623035:web:fcdda638bac10e0d0e6f5e',
  messagingSenderId: '408681623035',
  projectId: 'sabdaapp-2d974',
  authDomain: 'sabdaapp-2d974.firebaseapp.com',
  storageBucket: 'sabdaapp-2d974.firebasestorage.app',
});

// Dapatkan instance messaging
const messaging = firebase.messaging();

// Tangani background message
messaging.onBackgroundMessage(function(payload) {
  console.log('Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png' // opsional
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
