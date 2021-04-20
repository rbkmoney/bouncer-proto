/**
 * Модель контекстов для принятия решений контроля доступа.
 */

namespace java com.rbkmoney.bouncer.context.v1
namespace erlang bctx_v1

typedef i32 Version
const Version HEAD = 1

/**
 * Отметка во времени согласно RFC 3339.
 *
 * Строка должна содержать дату и время в UTC в следующем формате:
 * `2020-03-22T06:12:27Z`.
 */
typedef string Timestamp

/**
 * Контекст для принятия решений, по сути аннотированный набором атрибутов.
 * Контексты можно компоновать между собой.
 */
struct ContextFragment {

    1: required Version vsn = HEAD

    2: optional Environment env
    3: optional Auth auth
    4: optional User user
    5: optional Requester requester

    6: optional ContextCommonAPI capi
    7: optional ContextOrgManagement orgmgmt
    8: optional ContextUrlShortener shortener
    9: optional ContextBinapi binapi
   11: optional ContextAnalyticsAPI anapi
   18: optional ContextWalletAPI wapi

   10: optional ContextPaymentProcessing payment_processing
   12: optional ContextPayouts payouts
   13: optional ContextWebhooks webhooks
   14: optional ContextReports reports

   15: optional ContextWallet wallet
   16: optional ContextWalletWebhooks wallet_webhooks
   17: optional ContextWalletReports wallet_reports
}

/**
 * Атрибуты текущего окружения.
 */
struct Environment {
    1: optional Timestamp now
    2: optional Deployment deployment
}

struct Deployment {
    /**
     *  - "Production"
     *  - "Staging"
     *  - ...
     */
    1: optional string id
}

/**
 * Атрибуты средства авторизации.
 */
struct Auth {
    1: optional string method
    2: optional set<AuthScope> scope
    3: optional Timestamp expiration
    4: optional Token token
}

/**
 * Известные методы авторизации.
 * Используются в качестве значения свойства `auth.method`.
 */
const string AuthMethod_ApiKey = "ApiKey"
const string AuthMethod_SessionToken = "SessionToken"
const string AuthMethod_InvoiceAccessToken = "InvoiceAccessToken"
const string AuthMethod_InvoiceTemplateAccessToken = "InvoiceTemplateAccessToken"
const string AuthMethod_CustomerAccessToken = "CustomerAccessToken"

struct AuthScope {
    1: optional Entity party
    2: optional Entity shop
    3: optional Entity invoice
    4: optional Entity invoice_template
    5: optional Entity customer
}

struct Token {
    /**
     * Например, [`jti`][1] в случае использования JWT в качестве токенов.
     *
     * [1]: https://tools.ietf.org/html/rfc7519#section-4.1.7
     */
    1: optional string id
}

/**
 * Атрибуты пользователя.
 */
struct User {
    1: optional string id
    2: optional Entity realm
    3: optional string email
    4: optional set<Organization> orgs
}

struct Organization {
    1: optional string id
    2: optional Entity owner
    3: optional set<OrgRole> roles
    4: optional Entity party
}

struct OrgRole {
    /**
     * Например:
     *  - "Administrator"
     *  - "Manager"
     *  - ...
     */
    1: optional string id
    2: optional OrgRoleScope scope
}

struct OrgRoleScope {
    1: optional Entity shop
    2: optional Entity wallet
}

/**
 * Атрибуты отправителя запроса.
 */
struct Requester {
    1: optional string ip
}

/**
 * Контекст, получаемый из сервисов, реализующих один из интерфейсов протокола
 * https://github.com/rbkmoney/damsel/tree/master/proto/payment_processing.thrift
 * (например invoicing в hellgate)
 * и содержащий _проверенную_ информацию
 */
struct ContextPaymentProcessing {
    1: optional Invoice invoice
    2: optional InvoiceTemplate invoice_template
    3: optional Customer customer
}

struct Invoice {
    1: optional string id
    3: optional Entity party
    4: optional Entity shop
    5: optional set<Payment> payments
}

struct Payment {
    1: optional string id
    3: optional set<Entity> refunds
}

struct InvoiceTemplate {
    1: optional string id
    2: optional Entity party
    3: optional Entity shop
}

struct Customer {
    1: optional string id
    2: optional Entity party
    3: optional Entity shop
    4: optional set<Entity> bindings
}

/**
 * Контекст, получаемый из сервисов, реализующих протоколы сервиса [вебхуков]
 * (https://github.com/rbkmoney/damsel/tree/master/proto/webhooker.thrift)
 * и содержащий _проверенную_ информацию.
 */
struct ContextWebhooks {
    1: optional Webhook webhook
}

struct Webhook {
    1: optional string id
    2: optional Entity party
    3: optional WebhookFilter filter
}

struct WebhookFilter {
    1: optional string topic
    2: optional Entity shop
}

/**
 * Контекст, получаемый из сервисов, реализующих протоколы сервиса [отчётов]
 * (https://github.com/rbkmoney/reporter_proto/tree/master/proto/reports.thrift)
 * и содержащий _проверенную_ информацию.
 */
struct ContextReports {
    1: optional Report report
}

struct Report {
    1: optional string id
    2: optional Entity party
    3: optional Entity shop
    4: optional set<Entity> files
}

/**
 * Контекст, получаемый из сервисов, реализующих протоколы сервиса [выплат]
 * (https://github.com/rbkmoney/damsel/tree/master/proto/payout_processing.thrift)
 * и содержащий _проверенную_ информацию.
 */
struct ContextPayouts {
    1: optional Payout payout
}

struct Payout {
    1: optional string id
    2: optional Entity party
    3: optional Entity contract
    4: optional Entity shop
}

/**
 * Контекст, получаемый из сервисов, реализующих один из интерфейсов протокола
 * (https://github.com/rbkmoney/fistful-proto)
 * (например wallet в fistful-server)
 * и содержащий _проверенную_ информацию
 */
struct ContextWallet {
    1: optional Identity identity
    2: optional Wallet wallet
    3: optional Withdrawal withdrawal
    4: optional Deposit deposit
    5: optional P2PTransfer p2p_transfer
    6: optional P2PTransferTemplate p2p_transfer_template
    7: optional W2WTransfer w2w_transfer
    8: optional Source source
    9: optional Destination destination
}

struct Identity {
    1: optional string id
    3: optional Entity party
}

struct Wallet {
    1: optional string id
    3: optional Entity party
}

struct Withdrawal {
    1: optional string id
    3: optional Entity party
}

struct Deposit {
    1: optional string id
    3: optional Entity party
}

struct P2PTransfer {
    1: optional string id
    3: optional Entity party
}

struct P2PTransferTemplate {
    1: optional string id
    3: optional Entity party
}

struct W2WTransfer {
    1: optional string id
    3: optional Entity party
}

struct Source {
    1: optional string id
    3: optional Entity party
}

struct Destination {
    1: optional string id
    3: optional Entity party
}

/**
 * Контекст, получаемый из сервисов, реализующих протоколы сервиса [вебхуков]
 * (https://github.com/rbkmoney/fistful-proto/blob/master/proto/webhooker.thrift)
 * и содержащий _проверенную_ информацию.
 */
struct ContextWalletWebhooks {
    1: optional WalletWebhook webhook
}

struct WalletWebhook {
    1: optional string id
    2: optional Entity party
    3: optional WalletWebhookFilter filter
}

struct WalletWebhookFilter {
    1: optional string topic
    2: optional Entity withdrawal
    3: optional Entity destination
}

/**
 * Контекст, получаемый из сервисов, реализующих протоколы сервиса [отчётов]
 * (https://github.com/rbkmoney/fistful-reporter-proto)
 * (например wallet в fistful-server)
 * и содержащий _проверенную_ информацию
 */
struct ContextWalletReports {
    1: optional WalletReport report
}

struct WalletReport {
    1: optional string id
    2: optional Entity party
    4: optional set<Entity> files
}

/**
 * Атрибуты Common API.
 * Данные, присланные _клиентом_ в явном виде как часть запроса
 */
struct ContextCommonAPI {
    1: optional CommonAPIOperation op
}

struct CommonAPIOperation {
    /**
     * Например:
     *  - "GetMyParty"
     *  - "CreateInvoice"
     *  - ...
     */
    1: optional string id
    2: optional Entity party
    3: optional Entity shop
    7: optional Entity contract
    4: optional Entity invoice
    5: optional Entity payment
    6: optional Entity refund
    8: optional Entity invoice_template
    9: optional Entity customer
    10: optional Entity binding
    11: optional Entity report
    12: optional Entity file
    13: optional Entity webhook
    14: optional Entity claim
    15: optional Entity payout
}

/**
 * Атрибуты Organization Management.
 */
struct ContextOrgManagement {
    1: optional OrgManagementOperation op
    2: optional OrgManagementInvitation invitation
}

struct OrgManagementOperation {
    /**
     * Например:
     *  - "InquireMembership"
     *  - "ExpelOrgMember"
     *  - ...
     */
    1: optional string id
    2: optional Entity organization
    3: optional User member
    4: optional OrgRole role
}

struct OrgManagementInvitation {
    3: optional string id
    1: optional Invitee invitee
    2: optional Entity organization
}

struct Invitee {
    1: optional string email
}

/**
 * Атрибуты Url Shortener.
 */
struct ContextUrlShortener {
    1: optional UrlShortenerOperation op
}

struct UrlShortenerOperation {
    /**
     * Например:
     *  - "ShortenUrl"
     *  - "GetShortenedUrl"
     *  - "DeleteShortenedUrl"
     */
    1: optional string id
    2: optional ShortenedUrl shortened_url
}

struct ShortenedUrl {
    1: optional string id
    2: optional Entity owner
}


struct ContextBinapi {
    1: required BinapiOperation op
}

struct BinapiOperation {
    /**
     * Например:
     *  - "LookupCardInfo"
     *  - ...
     */
    1: required string id
    2: optional Entity party
}

/**
 * Атрибуты AnalyticsAPI.
 */
struct ContextAnalyticsAPI {
    1: optional AnalyticsAPIOperation op
}

struct AnalyticsAPIOperation {
    /**
     * Например:
     *  - "GetPaymentsAmount"
     *  - "CreateReport"
     *  - "SearchInvoices"
     */
    1: optional string id
    2: optional Entity party
    3: optional Entity shop
    4: optional Entity report
    5: optional Entity file
}

/**
 * Атрибуты WalletAPI.
 */
struct ContextWalletAPI {
    1: optional WalletAPIOperation op
}

struct WalletAPIOperation {
    /**
     * Например:
     *  - "ListDestinations"
     *  - "GetIdentity"
     *  - "CreateWebhook"
     */
    1: optional string id
    2: optional Entity party
    3: optional Entity identity
    4: optional Entity wallet
    5: optional Entity withdrawal
    6: optional Entity deposit
    7: optional Entity p2p_transfer
    8: optional Entity p2p_transfer_template
    9: optional Entity w2w_transfer
    10: optional Entity source
    11: optional Entity destination
    12: optional Entity report
    13: optional Entity file
    14: optional Entity webhook
}

/**
 * Нечто уникально идентифицируемое.
 *
 * Рекомендуется использовать для обеспечения прямой совместимости, в случае
 * например, когда в будущем мы захотим расширить набор атрибутов какой-либо
 * сущности, добавив в неё что-то кроме идентификатора.
 */
struct Entity {
    1: optional string id
}
