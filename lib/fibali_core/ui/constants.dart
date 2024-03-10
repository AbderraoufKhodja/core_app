import 'package:faker/faker.dart';

const List<dynamic> kImages = [
  "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
  "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
  "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
  "https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg",
  "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg",
  "https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_.jpg",
  "https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_.jpg",
  "https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_.jpg",
  "https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg",
  "https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg",
  "https://fakestoreapi.com/img/71kWymZ+c+L._AC_SX679_.jpg",
  "https://fakestoreapi.com/img/61mtL65D4cL._AC_SX679_.jpg",
  "https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg",
  "https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_.jpg",
  "https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_.jpg",
  "https://fakestoreapi.com/img/81XH0e8fefL._AC_UY879_.jpg",
  "https://fakestoreapi.com/img/71HblAHs5xL._AC_UY879_-2.jpg",
  "https://fakestoreapi.com/img/71z3kpMAYsL._AC_UY879_.jpg",
  "https://fakestoreapi.com/img/51eg55uWmdL._AC_UX679_.jpg",
  "https://fakestoreapi.com/img/61pHAEJ4NML._AC_UX679_.jpg",
];
final kFaker = Faker();

//Firebase

const usersCollection = 'users';
const swapItemsCollection = 'swapItems';
const swapItemsListsCollection = 'swapItemsLists';
const appreciationListsCollection = 'appreciationLists';
const swapAppreciationListsCollection = 'swapAppreciationLists';
// const usersInterestCollection = 'usersInterest';
const swapMatchesCollection = 'swapMatches';
const notificationsCollection = 'notifications';

const chatsCollection = 'chats';
const callEventsCollection = 'callEvents';
const appointmentEventsCollection = 'appointmentEvents';
const viewsCollection = 'views';
const itemsCollection = 'items';
const messagesCollection = 'messages';
const commentsCollection = 'comments';
const postsCollection = 'posts';
const likesCollection = 'likes';
const translatorsCollection = 'translators';
const relationsCollection = 'relations';

const kVapidKey =
    "BNFqwqAYPVulDQJVmNFvCYdJ6caP95wl-Kzixl_mnI8zHCY8MWsj_X07G5ISO6weIFnz4DXg3SOYrX5jTbfi_UA";

//Routes
const homeScreen = '/';
const callScreen = '/callScreen';
const testScreen = '/testScreen';

//Agora
// const agoraAppId = APP_ID; //replace with your agora app id
// const agoraTestChannelName =
//     'newChannel'; //replace with your agora channel name
// const agoraTestToken =
//     '006effbIACQIrib0zw+jFMnUP0OBgJajy/o8utZ2Zg9CqRnJo7WwAAAAAEABUm4+syy+mYgEAAQDOL6Zi'; //replace with your agora token

// //EndPoints -- this is for generating call token programmatically for each call
// const cloudFunctionBaseUrl =
//     'https://us-central1-agora-409098655.cloudfunctions.net/'; //replace with your clouded api base url
// const fireCallEndpoint =
//     'app/access_token'; //replace with your clouded api endpoint

const int callDurationInSec = 60;

enum CountriesIso {
  DZ,
  MA,
  TN,
  EG,
  CN,
}

enum BusinessTypes { retailer, translator }

const userTerms = '''
Welcome to Fibali, the app that connects you with people who want to swap   items they no longer need. These user terms govern your use of Fibali and the services we provide. By using Fibali, you agree to these terms and our privacy policy.

#### 1. Eligibility

You must be at least 13 years old to use Fibali. If you are under 18, you must have the permission of your parent or guardian to use Fibali. You must also comply with any applicable laws and regulations in your jurisdiction.

#### 2. Account

You must create an account to use Fibali. You are responsible for keeping your account secure and confidential. You must not share your account with anyone else or use someone else's account without their permission. You must also provide accurate and truthful information about yourself and your items. You must update your information if it changes.

#### 3. Content

You are solely responsible for the content you post, share, or send on Fibali, such as photos, videos, messages, ratings, reviews, or any other information. You must not post any content that is illegal, harmful, offensive, abusive, harassing, defamatory, infringing, deceptive, fraudulent, or otherwise objectionable. You must also respect the rights and privacy of others and not post any content that violates their intellectual property rights, personal data, or other rights. We reserve the right to remove any content that violates these terms or our policies at our sole discretion. We may also suspend or terminate your account if you repeatedly violate these terms or our policies.

#### 4. Swapping

Fibali allows you to swap items with other users based on your preferences, location, and availability. You can browse items posted by other users or post items of your own. You can connect with other users and negotiate a swap. You can meet up with the other user and complete the swap. You are solely responsible for the items you swap and the swaps you make on Fibali. You must ensure that the items you swap are in good condition, match the description and photos you provided, and do not violate any laws or regulations. You must also ensure that the swaps you make are fair, safe, and legal. We do not guarantee the quality, safety, legality, or availability of any items or swaps on Fibali. We do not endorse or verify any users or items on Fibali. We are not involved in any swaps or transactions between users on Fibali. We are not liable for any disputes, damages, losses, injuries, or claims arising from or related to any items or swaps on Fibali.

#### 5. Ratings and Reviews

Fibali allows you to rate and review other users after each swap. You can also see the ratings and reviews of other users before you swap with them. You must provide honest and accurate ratings and reviews based on your experience with the other user and their item. You must not provide ratings and reviews that are false, misleading, abusive, or otherwise inappropriate. We reserve the right to remove any ratings or reviews that violate these terms or our policies at our sole discretion. We may also suspend or terminate your account if you repeatedly violate these terms or our policies.

#### 6. Restrictions

You must not use Fibali for any purpose that is illegal, harmful, abusive, fraudulent, or otherwise objectionable. You must not use Fibali to spam, harass, threaten, or impersonate others. You must not use Fibali to collect or solicit personal data or other information from others without their consent. You must not use Fibali to interfere with or disrupt the operation of Fibali or the services we provide. You must also not attempt to access, modify, reverse engineer, decompile, disassemble, or otherwise tamper with Fibali or the services we provide. You must also not use any automated means, such as bots, scripts, or crawlers, to access or use Fibali or the services we provide. We reserve the right to monitor, investigate, and enforce these terms and our policies at our sole discretion. We may also suspend or terminate your account or access to Fibali or the services we provide if you violate these terms or our policies.

#### 7. Changes

We may change these terms and our policies at any time and for any reason. We will notify you of any changes by posting them on Fibali or by sending you an email. Your continued use of Fibali after the changes take effect constitutes your acceptance of the changes. If you do not agree to the changes, you must stop using Fibali and delete your account.

#### 8. Disclaimer

Fibali and the services we provide are provided "as is" and "as available" without any warranties of any kind, either express or implied. We do not warrant that Fibali or the services we provide will be uninterrupted, error-free, secure, accurate, reliable, or suitable for your needs. We do not warrant that any content, items, swaps, ratings, reviews, or other information on Fibali or the services we provide will be complete, correct, current, or valid. We do not warrant that any defects or errors on Fibali or the services we provide will be corrected.

#### 9. Limitation of Liability

To the fullest extent permitted by law, we are not liable for any direct, indirect, incidental, special, consequential, punitive, or exemplary damages arising from or related to your use of or inability to use Fibali or the services we provide. This includes but is not limited to any damages for loss of profits, revenue, data, goodwill, reputation, or other intangible losses. This also includes but is not limited to any damages arising from or related to any content, items, swaps, ratings, reviews, or other information on Fibali or the services we provide. This also includes but is not limited to any damages arising from or related to any conduct, communication, or interaction with other users or third parties on Fibali or the services we provide. This also includes but is not limited to any damages arising from or related to any unauthorized access, use, or disclosure of your account or personal data.

#### 10. Indemnification

You agree to indemnify, defend, and hold us harmless from and against any and all claims, liabilities, damages, losses, costs, expenses, and fees (including reasonable attorneys' fees) arising from or related to your use of or inability to use Fibali or the services we provide. This includes but is not limited to any claims arising from or related to any content, items, swaps, ratings, reviews, or other information you post, share, or send on Fibali or the services we provide. This also includes but is not limited to any claims arising from or related to any conduct, communication, or interaction with other users or third parties on Fibali or the services we provide. This also includes but is not limited to any claims arising from or related to any violation of these terms or our policies.

#### 11. General

These terms and our policies constitute the entire agreement between you and us regarding your use of Fibali and the services we provide. They supersede any prior or contemporaneous agreements, communications, or understandings between you and us regarding your use of Fibali and the services we provide. If any provision of these terms or our policies is found to be invalid or unenforceable by a court of competent jurisdiction, that provision will be severed and the remaining provisions will remain in full force and effect. Our failure to enforce any right or provision of these terms or our policies will not be considered a waiver of that right or provision. We may assign or transfer our rights and obligations under these terms or our policies to any person or entity without your consent. You may not assign or transfer your rights and obligations under these terms or our policies to any person or entity without our consent.

#### 12. Contact

If you have any questions, comments, or feedback about Fibali or the services we provide, please contact us at <piicubic@gmail.com>. We would love to hear from you. Thank you for using Fibali!
''';
