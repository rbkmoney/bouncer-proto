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
   10: optional ContextPaymentProcessing payment_processing
   11: optional ContextAnalyticsAPI anapi
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
    /**
     *  - "ApiKey"
     *  - "SessionToken"
     *  - "InvoiceAccessToken"
     *  - ...
     */
    1: optional string method
    2: optional set<AuthScope> scope
    3: optional Timestamp expiration
}

struct AuthScope {
    1: optional Entity party
    2: optional Entity shop
    3: optional Entity invoice
    4: optional Entity invoice_template
    5: optional Entity customer
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
 * Контекст, получаемый из сервисов, реализующих внутренний интерфейс
 * https://github.com/rbkmoney/damsel/tree/master/proto/payment_processing.thrift#L996
 * (например invoicing в hellgate)
 * и содержащий _проверенную_ информацию
 */
struct ContextPaymentProcessing {
    1: optional Party party
    2: optional Invoice invoice
    3: optional Payment payment
    4: optional InvoiceTemplate invoice_template
    5: optional Customer customer
}

struct Party {
    1: optional string id
    2: optional Entity shop
}

struct Invoice {
    1: optional string id
    3: optional Entity party
    2: optional i32 num_payments
}

struct Payment {
    1: optional string id
    3: optional Invoice invoice
    2: optional i32 num_refunds
}

struct InvoiceTemplate {
    1: optional string id
    2: optional Entity party
}

struct Customer {
    1: optional string id
    2: optional Entity party
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
    4: optional Entity invoice
    5: optional Entity payment
    6: optional Entity refund
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
    3: optional set<Entity> shops
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
