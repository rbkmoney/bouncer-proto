namespace java com.rbkmoney.bouncer.rstn
namespace erlang brstn

typedef i32 Version
const Version HEAD = 1

/**
 * Ограничения применимые в сервисе
 *
 * Так как ограничения предпологаются только на конкретных сервисах с их
 * уникальными данными, то нет нужды запаковывать их в строку
 */
struct Restrictions {
    1: required Version vsn = HEAD
    2: optional RestrictionsAnalyticsAPI anapi
}

/**
 * Ограничения накладываемые на сервис АПИ Аналитики
 */
struct RestrictionsAnalyticsAPI {
    1: required AnalyticsAPIOperationRestrictions op
}

struct AnalyticsAPIOperationRestrictions {
    1: required set<Entity> shops
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
