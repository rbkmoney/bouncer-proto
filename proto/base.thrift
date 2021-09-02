namespace java com.rbkmoney.bouncer.base
namespace erlang bouncer_base

typedef i32 Version

/**
 * Отметка во времени согласно RFC 3339.
 *
 * Строка должна содержать дату и время в UTC в следующем формате:
 * `2020-03-22T06:12:27Z`.
 */
typedef string Timestamp


typedef string EntityID

/**
 * Нечто уникально идентифицируемое.
 *
 * Рекомендуется использовать для обеспечения прямой совместимости, в случае
 * например, когда в будущем мы захотим расширить набор атрибутов какой-либо
 * сущности, добавив в неё что-то кроме идентификатора.
 */
struct Entity {
    1: optional EntityID id
    2: optional string type
    3: optional EntityID party

    4: optional WalletAttrs wallet
}

struct Cash {
    1: optional string amount
    2: optional string currency
}

struct WalletAttrs {
    1: optional EntityID identity
    2: optional EntityID wallet
    3: optional Cash body
    4: optional WalletReportAttrs report
}

struct WalletReportAttrs {
    /**
    * TODO: Кажется не очень правильно ссылаться на список объектов,
    * достаточно, чтобы каждый из этих объектов ссылался на объект, которому он принадлежит
    */
    1: optional set<EntityID> files
}
