// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:paypal_sdk/catalog_products.dart';
// import 'package:paypal_sdk/core.dart';
// import 'package:paypal_sdk/src/webhooks/webhooks_api.dart';
// import 'package:paypal_sdk/subscriptions.dart';
// import 'package:paypal_sdk/webhooks.dart';

// const _clientId = 'clientId';
// const _clientSecret = 'clientSecret';

// class PaypalPaymentBloc extends Cubit {
//   PaypalPaymentBloc(super.initialState);

//   AccessToken? accessToken; // load existing token here if available

//   var paypalEnvironment =
//       const PayPalEnvironment.sandbox(clientId: _clientId, clientSecret: _clientSecret);

//   late PayPalHttpClient payPalHttpClient = PayPalHttpClient(paypalEnvironment,
//       accessToken: accessToken, accessTokenUpdatedCallback: (accessToken) async {
//     // Persist token for re-use
//   });

//   // await catalogProductsExamples(payPalHttpClient);
//   // await subscriptionExamples(payPalHttpClient);
//   // await webhookExamples(payPalHttpClient);

//   Future<void> catalogProductsExamples(PayPalHttpClient payPalHttpClient) async {
//     var productsApi = CatalogProductsApi(payPalHttpClient);

//     // Get product details
//     try {
//       var product = await productsApi.showProductDetails('product_id');
//       debugPrint(product.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // List products
//     try {
//       var productsCollection = await productsApi.listProducts();

//       for (var product in productsCollection.products) {
//         debugPrint(product.toString());
//       }
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Create product
//     try {
//       var createProductRequest = ProductRequest(
//           name: 'test_product', type: ProductType.digital, description: 'test_description');

//       var product = await productsApi.createProduct(createProductRequest);

//       debugPrint(product.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Update product
//     try {
//       await productsApi.updateProduct('product_id',
//           [Patch(op: PatchOperation.replace, path: '/description', value: 'Updated description')]);
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   Future<void> subscriptionExamples(PayPalHttpClient payPalHttpClient) async {
//     var subscriptionsApi = SubscriptionsApi(payPalHttpClient);

//     // Plans
//     // List plans
//     try {
//       var planCollection = await subscriptionsApi.listPlans();
//       debugPrint(planCollection.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Create plan
//     try {
//       var planRequest = PlanRequest(
//           productId: 'PROD-3XF87627UU805523Y',
//           name: 'Test plan',
//           billingCycles: [
//             BillingCycle(
//                 pricingScheme: PricingScheme(
//                   fixedPrice: Money(currencyCode: 'GBP', value: '5'),
//                 ),
//                 frequency: Frequency(
//                   intervalUnit: IntervalUnit.month,
//                   intervalCount: 1,
//                 ),
//                 tenureType: TenureType.regular,
//                 sequence: 1)
//           ],
//           paymentPreferences: PaymentPreferences(
//               autoBillOutstanding: true,
//               setupFee: Money(currencyCode: 'GBP', value: '1.00'),
//               setupFeeFailureAction: SetupFeeFailureAction.cancel,
//               paymentFailureThreshold: 2));
//       var billingPlan = await subscriptionsApi.createPlan(planRequest);
//       debugPrint(billingPlan.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Update plan
//     try {
//       await subscriptionsApi.updatePlan('P-6KG67732XY2608640MFGL3RY',
//           [Patch(op: PatchOperation.replace, path: '/description', value: 'Test description')]);
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Show plan details
//     try {
//       var billingPlan = await subscriptionsApi.showPlanDetails('P-6KG67732XY2608640MFGL3RY');
//       debugPrint(billingPlan.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Activate plan
//     try {
//       await subscriptionsApi.activatePlan('P-6KG67732XY2608640MFGL3RY');
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Deactivate plan
//     try {
//       await subscriptionsApi.deactivatePlan('P-6KG67732XY2608640MFGL3RY');
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Update plan pricing
//     try {
//       await subscriptionsApi.updatePlanPricing(
//           'P-6KG67732XY2608640MFGL3RY',
//           PricingSchemesUpdateRequest([
//             PricingSchemeUpdateRequest(
//                 billingCycleSequence: 1,
//                 pricingScheme: PricingScheme(
//                   fixedPrice: Money(currencyCode: 'GBP', value: '5.0'),
//                 ))
//           ]));
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Subscriptions
//     // Create subscription
//     try {
//       var createSubscriptionRequest =
//           SubscriptionRequest(planId: 'P-6KG67732XY2608640MFGL3RY', customId: 'custom_id');
//       var subscription = await subscriptionsApi.createSubscription(createSubscriptionRequest);
//       debugPrint(subscription.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Update subscription
//     try {
//       await subscriptionsApi.updateSubscription('I-1WSNAWATBCXP',
//           [Patch(op: PatchOperation.add, path: '/custom_id', value: 'updated_custom_id')]);
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Show subscription details
//     try {
//       var subscription = await subscriptionsApi.showSubscriptionDetails('I-1WSNAWATBCXP');
//       debugPrint(subscription.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Activate subscription
//     try {} on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Cancel subscription
//     try {
//       await subscriptionsApi.cancelSubscription('I-93KN27174NGR', 'No longer needed');
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Capture authorized payment on subscription
//     try {
//       var request = SubscriptionCaptureRequest(
//           note: 'Outstanding balance', amount: Money(currencyCode: 'GBP', value: '5.00'));

//       var response =
//           await subscriptionsApi.captureAuthorizedPaymentOnSubscription('I-1WSNAWATBCXP', request);
//       debugPrint(response.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Revise plan or quantity of subscription
//     try {
//       var request = SubscriptionReviseRequest(
//           planId: 'P-9DR273747C8107746MFGHYKY',
//           shippingAmount: Money(currencyCode: 'USD', value: '2.0'));

//       var response = await subscriptionsApi.reviseSubscription('I-1WSNAWATBCXP', request);
//       debugPrint(response.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Suspend subscription
//     try {
//       var request = const Reason('Out of stock');
//       await subscriptionsApi.suspendSubscription('I-1WSNAWATBCXP', request);
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // List transactions for subscription
//     try {
//       var response = await subscriptionsApi.listTransactions(
//           'I-1WSNAWATBCXP', '2021-09-01T07:50:20.940Z', '2021-09-29T07:50:20.940Z');
//       debugPrint(response.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   Future<void> webhookExamples(PayPalHttpClient payPalHttpClient) async {
//     var webhooksApi = WebhooksApi(payPalHttpClient);

//     // List webhooks
//     try {
//       var webhooksList = await webhooksApi.listWebhooks();
//       debugPrint(webhooksList.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Create webhook
//     try {
//       var webhook = const Webhook(url: 'https://api.test.com/paypal_callback', eventTypes: [
//         EventType(name: 'BILLING.SUBSCRIPTION.CREATED'),
//         EventType(name: 'BILLING.SUBSCRIPTION.CANCELLED'),
//       ]);

//       webhook = await webhooksApi.createWebhook(webhook);
//       debugPrint(webhook.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Delete webhook
//     try {
//       await webhooksApi.deleteWebhook('1HG80537L4140544T');
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Update webhook
//     try {
//       await webhooksApi.updateWebhook('5B760822JX046254S', [
//         Patch(
//             op: PatchOperation.replace,
//             path: '/url',
//             value: 'https://api.test.com/paypal_callback_new'),
//       ]);
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // Show webhook details
//     try {
//       var webhook = await webhooksApi.showWebhookDetails('7BS56736HU608525B');
//       debugPrint(webhook.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // List event types for webhook
//     try {
//       var eventTypesList = await webhooksApi.listEventSubscriptionsForWebhook('7BS56736HU608525B');
//       debugPrint(eventTypesList.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }

//     // List available events
//     try {
//       var eventTypesList = await webhooksApi.listAvailableEvents();
//       debugPrint(eventTypesList.toString());
//     } on ApiException catch (e) {
//       debugPrint(e.toString());
//     }
//   }
// }
