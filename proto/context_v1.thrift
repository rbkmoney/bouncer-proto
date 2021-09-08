/**
 * Модель контекстов для принятия решений контроля доступа.
 */

namespace java com.rbkmoney.bouncer.context.v1
namespace erlang bctx_v1

include "base.thrift"

typedef base.Version Version
typedef base.Timestamp Timestamp
typedef base.Entity Entity
typedef base.EntityID EntityID
typedef base.Cash Cash

const Version HEAD = 2

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
   15: optional ContextClaimManagement claimmgmt
   17: optional ContextPaymentTool payment_tool
   /**
   * Наборы атрибутов для контекста сервиса кошельков, см. описание ниже.
   */
   19: optional set<Entity> wallet
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
const string AuthMethod_P2PTransferTemplateTicket = "P2PTransferTemplateTicket"
const string AuthMethod_P2PTransferTemplateAccessToken = "P2PTransferTemplateAccessToken"

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
 * (например данные о платёжных сущностях invoicing в hellgate)
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

/** wallet
 * Контекст, получаемый из сервисов, реализующих один из интерфейсов протокола
 * (https://github.com/rbkmoney/fistful-proto)
 * (например wallet в fistful-server)
 * и содержащий _проверенную_ информацию

Информация о возможных объектах и полях к ним относящихся:

type = "Identity" {
    1: id
    2: party
}

type = "Wallet" {
    1: id
    2: identity
    3: wallet_grant_body
}

type = "Withdrawal" {
    1: id
    2: wallet
}

type = "Deposit" {
    1: id
    2: wallet
}

type = "W2WTransfer" {
    1: id
    2: wallet
}

type = "Source" {
    1: id
    2: identity
}

type = "Destination" {
    1: id
    2: identity
}

*/

/** wallet_webhooks
 * Контекст, получаемый из сервисов, реализующих протоколы сервиса [вебхуков]
 * (https://github.com/rbkmoney/fistful-proto/blob/master/proto/webhooker.thrift)
 * и содержащий _проверенную_ информацию.

Информация о возможных объектах и полях к ним относящихся:

type = "WalletWebhook" {
    1: id
    2: identity
    3: wallet
}

*/

/** wallet_reports
 * Контекст, получаемый из сервисов, реализующих протоколы сервиса [отчётов]
 * (https://github.com/rbkmoney/fistful-reporter-proto)
 * (например wallet в fistful-server)
 * и содержащий _проверенную_ информацию

Информация о возможных объектах и полях к ним относящихся:

type = "WalletReport" {
    1: id
    2: identity
    3: files
}

*/

/**
 * Контекст Common API.
 */
struct ContextCommonAPI {
    1: optional CommonAPIOperation op
}

/**
 * Арибуты операции Common API.
 * Данные, присланные _клиентом_ в явном виде как часть запроса
 */
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
    16: optional ClientInfo client_info
}

/*
 * Дополнительная информация о клиенте и его устройствах
 * передаваемая в некоторых запросах в явном виде.
 */
struct ClientInfo {
    /*
     * ip адрес плательщика передаваемый в createPaymentResource
     */
    1: optional string ip
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
 * Атрибуты Claim Management API.
 */
struct ContextClaimManagement {
    1: optional ClaimManagementOperation op
}

struct ClaimManagementOperation {
    /**
     * Например:
     *  - "createClaim"
     *  - "revokeClaimByID"
     *  - ...
     */
    1: optional string id
    2: optional Entity party
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
 * Атрибуты платежного стредства.
 * Токены платежных интрументов создаются в createPaymentResource.
 * Этот контекст используется и для провайдерских токенов.
 * Привязка может быть сопоставлена с Auth конекстом или CommonAPIOperation.
 */
struct ContextPaymentTool {
    /**
     * Привязка токена платежного средства
     */
    1: optional AuthScope scope
    /**
     * Время жизни токена платежного средства
     */
    2: optional Timestamp expiration
}

/**
 * Атрибуты WalletAPI.
 */
struct ContextWalletAPI {
    1: optional WalletAPIOperation op
    2: optional set<WalletGrant> grants
}

/**
 * Контекст, получаемый из grant токена, предоставляющего доступ к кошельку или назначению
 * и содержащий _проверенную_ информацию.
 */

struct WalletGrant {
    1: optional EntityID wallet
    2: optional EntityID destination
    3: optional Cash body
    4: optional Timestamp created_at
    5: optional Timestamp expires_on
}

struct WalletAPIOperation {
    /**
     * Например:
     *  - "ListDestinations"
     *  - "GetIdentity"
     *  - "CreateWebhook"
     */
    1: optional string id
    2: optional EntityID party
    3: optional EntityID identity
    4: optional EntityID wallet
    5: optional EntityID withdrawal
    6: optional EntityID deposit
    7: optional EntityID w2w_transfer
    8: optional EntityID source
    9: optional EntityID destination
    10: optional EntityID report
    11: optional EntityID file
    12: optional EntityID webhook
}
