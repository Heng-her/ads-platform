// Service Worker for Ads Platform Web Push Notifications
self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(clients.claim());
});

self.addEventListener('push', function (event) {
  let data = {};
  if (event.data) {
    try {
      data = event.data.json();
    } catch (e) {
      data = { title: '🚀 New Campaign Published!', body: event.data.text() };
    }
  }

  const title = data.title || '🚀 New Campaign Published!';
  const options = {
    body: data.body || 'A new campaign has just been published on Ads Platform.',
    icon: data.icon || '/ads-platform.png',
    badge: data.badge || '/ads-platform.png',
    vibrate: [300, 100, 300, 100, 300], // Phone vibration pattern for lock screen alert
    tag: data.campaignId ? `campaign-${data.campaignId}` : `campaign-${Date.now()}`,
    renotify: true,
    requireInteraction: true, // Keep visible on lock screen until user interacts
    data: {
      url: data.url || '/'
    }
  };

  event.waitUntil(
    self.registration.showNotification(title, options)
  );
});

self.addEventListener('message', function (event) {
  if (event.data && event.data.type === 'SHOW_NOTIFICATION') {
    const { title, options } = event.data;
    event.waitUntil(
      self.registration.showNotification(title || 'Local Notification', options || {})
    );
  }
});

self.addEventListener('notificationclick', function (event) {
  event.notification.close();
  const targetUrl = event.notification.data?.url || '/';

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function (clientList) {
      for (let i = 0; i < clientList.length; i++) {
        const client = clientList[i];
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          return client.focus().then(function (focusedClient) {
            if (focusedClient && 'navigate' in focusedClient && targetUrl !== focusedClient.url) {
              return focusedClient.navigate(targetUrl);
            }
          });
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(targetUrl);
      }
    })
  );
});
