'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "1da05837178578d2a57f0a81bfd596a8",
"main.dart.js_79.part.js": "5308671b6424657d509612958ef1e0b2",
"main.dart.js_69.part.js": "2827a98fb4c85a389919a2e01c8375c1",
"main.dart.js_101.part.js": "a893b68ed351234094cea3f450e11f7e",
"main.dart.js_111.part.js": "e6374a2a7a51bdd90df41ab9e3c5aa07",
"main.dart.js_24.part.js": "2732f05409c86d95e551d20b39ed9a66",
"main.dart.js_34.part.js": "debd1e0e06ee013c6a7aaa463289adac",
"main.dart.js_46.part.js": "dced24fe2fa0442e994f76432e97aeff",
"main.dart.js_56.part.js": "5d490d57dae7bee69843c7339618ad7b",
"version.json": "8dc153b3217dd8047d42ffa60f996287",
"main.dart.js_7.part.js": "b3a00361ec7526db4c40fc693a2cea23",
"main.dart.js_60.part.js": "523e03a3e5ad8452c55f8eab37948cf2",
"main.dart.js_70.part.js": "8d65e07608425f8f0b2907b3e2331c0d",
"main.dart.js_12.part.js": "3d17d631942612545d03aa3b9ba18638",
"main.dart.js_84.part.js": "731127cf9bdeca5df03d611595c056e9",
"main.dart.js_94.part.js": "c0d52a36eb492fdaaff64304a88ab516",
"main.dart.js_108.part.js": "b6bddc7874d902edc4bffbba77a91f74",
"main.dart.js_71.part.js": "73414f67c1d2dd9b343347e151e8dec3",
"main.dart.js_61.part.js": "794e179a948216601009bdb40b481801",
"main.dart.js_6.part.js": "725e9aabcea0be21b88d66140f93bb32",
"index.html": "c49b77a0b325598387f21e4f70e3eb2f",
"/": "c49b77a0b325598387f21e4f70e3eb2f",
"main.dart.js_13.part.js": "217620584887a6f972f95cfb8639b5f2",
"main.dart.js_109.part.js": "56dd9d37317f1fd1e678ba03260da1b5",
"main.dart.js_95.part.js": "8cbab21071dcfece06450e9bfb78dcaa",
"main.dart.js_85.part.js": "5c45a162b197c902cabd53cf48bf039c",
"main.dart.js_68.part.js": "2832d2165871d6eb31201d884a533efd",
"main.dart.js_78.part.js": "a88f798cccf4f76f51735a250061c4ea",
"main.dart.js_100.part.js": "3af5e6c8ac7e8f23d67626f98db6f0cd",
"main.dart.js_35.part.js": "f1f178d8157fc898fa8fefaf8261e862",
"main.dart.js_25.part.js": "9a427061c064a18c90fdc53b61fcf8dd",
"main.dart.js_57.part.js": "fc6d36fd0fd597288f950288c0c4331c",
"main.dart.js_47.part.js": "8c391541f7ae532d145f05ddc8660590",
"main.dart.js_11.part.js": "fb334819eaebae9a020251152309dd45",
"main.dart.js_63.part.js": "5cba45e0967631aaf3c9e2e1edb04dfb",
"main.dart.js_4.part.js": "d006070e62a7aa13d32b5b70b5eca9cc",
"main.dart.js_73.part.js": "79d702e07bc03b33e2b7b92dd003ae87",
"main.dart.js": "3b5628c3d2f9092730165db076c9c4e2",
"main.dart.js_97.part.js": "99938c3e091410bb401bb391eb8a4337",
"main.dart.js_18.part.js": "5ac3cac3b50dc16d7e3a21719af74e75",
"main.dart.js_45.part.js": "dd5305d077a3ce9e86238fca04364548",
"main.dart.js_27.part.js": "bbf13bfef9fd9589f7dd3ccb351dda3f",
"main.dart.js_37.part.js": "7cb391b7061a69b444fd202ac037322c",
"main.dart.js_102.part.js": "ca5f47c0bc0626abf653d2e9497010b4",
"main.dart.js_112.part.js": "a052b283187e82db23ab7d1d17a02102",
"main.dart.js_19.part.js": "5a1bb4dad24c7a04fb84f275c104c1e3",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_54.part.js": "d4508e4b005d922a5ad93a5fff7f1753",
"main.dart.js_44.part.js": "8d82336b16acb95db96f0fff4f979d79",
"main.dart.js_36.part.js": "386fed85b7559897f1c8aa65fe55b43b",
"main.dart.js_113.part.js": "ccd41199c6bef54d7e56fac89e637ef7",
"main.dart.js_103.part.js": "1db8fc7ef902da6e573626867c586178",
"main.dart.js_10.part.js": "66797633d8e983c11aa4855dee787bff",
"main.dart.js_72.part.js": "f354815c74100286ff3134fe72a629c5",
"main.dart.js_5.part.js": "39631b7a0e2ed20d0d35af1927811828",
"main.dart.js_62.part.js": "36c69c237082ee4c46adf49b404e0c5d",
"main.dart.js_96.part.js": "b651501346d3291ee2d86fcc8f0c2b16",
"main.dart.js_86.part.js": "29c42ebe0772cf5a67ff90cd0feb07df",
"main.dart.js_83.part.js": "53b6af6bc5cb94c94d9313d935b8d043",
"main.dart.js_93.part.js": "ba7fd8fc090b8df06f6d7d11ee298a54",
"main.dart.js_58.part.js": "48c88f1ed354cf2c0827945fa502f05d",
"main.dart.js_48.part.js": "1e23d4e7dea622ceb4533e31e6f58af9",
"main.dart.js_15.part.js": "41b0fe21cfce042817fb32b21d16ac5f",
"main.dart.js_67.part.js": "790addbc4bdd5cd94287cc938875088e",
"main.dart.js_77.part.js": "eb380f8dfd4902ea0e86e78c6158f032",
"favicon.png": "99f829389560b4b7347d0d6766aa6afb",
"main.dart.js_41.part.js": "3c14b2ce78797a34890ef91072be0262",
"main.dart.js_51.part.js": "0d8c357209fc37d03c46110dab299f62",
"main.dart.js_106.part.js": "1ee2238ac336deff21a0258ae3008225",
"main.dart.js_23.part.js": "a235f12073896e9d1616a725ea3ca667",
"main.dart.js_33.part.js": "2bfc0ce06086a428bc1ad67f19af7283",
"main.dart.js_9.part.js": "b8aaa4163ed08a92bf8642ed1ada639e",
"main.dart.js_50.part.js": "22306eefbefeeca7fc4ecc20ad4334d7",
"main.dart.js_107.part.js": "525783f05b1eea0b282fccf54da4cd52",
"main.dart.js_32.part.js": "a0ff4e320b6ebfc8dcc68037d8855c9f",
"main.dart.js_22.part.js": "2e174aa2f919438b0517d2164fee7375",
"main.dart.js_8.part.js": "9dfc37b095ad141080153d8eefb3691b",
"icons/logo_loader.png": "f5ba66c71563f1d1d54492b968e415cc",
"manifest.json": "79f40eab047b89c2a9bc5aa8d5b52292",
"main.dart.js_92.part.js": "b28cc34f325d75530e17ff4241d18faa",
"main.dart.js_82.part.js": "d874e7bcf04c0136b347be3262ad28ad",
"main.dart.js_49.part.js": "54f48cf2dcbeff8f7cb4e84b42fddfad",
"lib/core/lib/shared_widgets/table_shimmer_loader.dart": "b51d89a4f1bec52688f13ffa611b085d",
"lib/core/constants.dart": "716114afc0d8c9929d9014db0f120914",
"main.dart.js_59.part.js": "10e0a6e778d818fbfacde1d532cd4eba",
"main.dart.js_14.part.js": "5b75485dc02825125731be7d696f4f87",
"main.dart.js_76.part.js": "015f501e18b1e35ff93e6c6e5a07f187",
"main.dart.js_1.part.js": "db1035a83251fff6ea9edea93798e466",
"deploy.sh": "63c8be3a586dfe6e1625b19ffda02517",
"main.dart.js_30.part.js": "09e65e5254f8e213d7257f1591143ae4",
"main.dart.js_105.part.js": "8945b850087c4c7c61dec1d103a070ea",
"main.dart.js_115.part.js": "a393187ba2f3eea588f29b71d86f0ac8",
"main.dart.js_99.part.js": "f857fb54e247089f45cdc16d1e3e7ca5",
"main.dart.js_89.part.js": "c5c342e8e399f18b824df7a298a5b59a",
"main.dart.js_42.part.js": "5d89895a6d08a609c30f043dcd7d8197",
"main.dart.js_52.part.js": "7cb6870943efe7bd1d3a253e4644a5c6",
"main.dart.js_39.part.js": "82e8c3ba3832bb74334b401b979f9e49",
"main.dart.js_29.part.js": "a6862c480084fe9d283e783e966f2c63",
"main.dart.js_80.part.js": "e5f51191183ebd322877f59c753a415e",
"main.dart.js_90.part.js": "d64ef2507d2c053626fbccd1a3aabebf",
"main.dart.js_64.part.js": "14f1156dbfd52edad9d7092884001b8c",
"main.dart.js_74.part.js": "e94eba47f3b8911509ea1511c7f30bc0",
"assets/NOTICES": "e0ec5c3b5f781c90167668f81e74f820",
"assets/FontManifest.json": "4575397130e2191fcfaebd9a8fef996d",
"assets/AssetManifest.bin.json": "3abd5976eb4a16cd550a31ef5614f217",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/iconsax/lib/assets/fonts/iconsax.ttf": "071d77779414a409552e0584dcbfd03d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "fe3ad02f88d68a55da206369b643484e",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/assets/images/logo.png": "f5ba66c71563f1d1d54492b968e415cc",
"main.dart.js_91.part.js": "5fa635b4fa6cd7f700999d05f302d7be",
"main.dart.js_81.part.js": "f2cf4b79edd697513033044e23c7e3ba",
"main.dart.js_38.part.js": "636dd37b687a9b393d6ddc92b3000a91",
"main.dart.js_75.part.js": "03e3da4540205d52d25d038e3575d656",
"main.dart.js_2.part.js": "2fa0939c9534c10d83e6c15c75261388",
"main.dart.js_65.part.js": "f205266d640e437409e30e9931f18d08",
"main.dart.js_17.part.js": "21c78e75fe80cbdb6cfbda70040bc1b1",
"main.dart.js_88.part.js": "cb6f34c97a6cdd8ea8df8cddf8b161f4",
"main.dart.js_98.part.js": "f2132646ccb1c09e14fe172dab4d6128",
"main.dart.js_31.part.js": "275d535177394141a8ebe03670f57873",
"main.dart.js_114.part.js": "261b284adeaec32dec648d48ed2d977a",
"main.dart.js_53.part.js": "7f420fcb54c007940afcce86901323c8",
"main.dart.js_43.part.js": "41d7d40fb0b3529c92e71927442638f5",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
