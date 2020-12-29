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
    4: optional Token token
}

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

    /**
     * Данные согласно спецификации [swag](https://github.com/rbkmoney/swag)
     * версий v1 и v2.
     */
    15: optional JSON params
    16: optional Specification spec
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

/**
 * Значение в JSON, согласно [RFC7159](https://tools.ietf.org/html/rfc7159).
 *
 * Подходит для передачи «сырых» данных запросов, структурированных согласно
 * сторонней спецификации.
 */
union JSON {
    1: Null nl
    2: bool b
    3: i32 i        // от -(2^31) до (2^31 - 1)
    4: double flt
    5: string str   // UTF-8 only
    6: Object obj   // Ключи свойств закодированы в UTF-8
    7: Array arr
}

enum Null { Null }
typedef list<JSON> Array
typedef map<string, JSON> Object

struct Specification {
    /**
     * Например:
     *  - "swag"
     *  - "swag-analytics"
     *  - "swag-org-management"
     */
    1: optional string name
    2: optional string version
}
