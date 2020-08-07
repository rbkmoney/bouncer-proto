/**
 * Модель контекстов для принятия решений контроля доступа.
 */

namespace java com.rbkmoney.bouncer.context.v1
namespace erlang bctx_v1

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
struct Context {

    1: optional Environment env
    2: optional Auth auth
    3: optional User user
    4: optional Requester requester

    5: optional ContextCommonAPI capi
    6: optional ContextOrgManagement orgmgmt

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
    3: optional set<OrgRole> Orgroles
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
 * Атрибуты Common API.
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
    4: optional Invoice invoice
    5: optional Payment payment
    6: optional Entity refund
}

struct Invoice {
    1: optional string id
    2: optional i32 num_payments
}

struct Payment {
    1: optional string id
    3: optional i32 num_refunds
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
    2: optional Entity org
    3: optional User member
    4: optional OrgRole role
}

struct OrgManagementInvitation {
    1: optional Invitee invitee
    2: optional Entity org
}

struct Invitee {
    1: optional string email
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
