namespace java com.rbkmoney.bouncer.decisions
namespace erlang bdcs

include "context.thrift"

typedef string ContextFragmentID

/**
 * Контекст для принятия решений
 */
struct Context {
    1: required map<ContextFragmentID, context.ContextFragment> fragments
}

/// Сервис принятия решений вида «можно» / «нельзя»

/** Идентификатор свода правил. */
typedef string RulesetID

enum Resolution {
    allowed
    forbidden
}

/**
 * Принятое решение.
 * Детали того, какие правила сработали и почему, можно увидеть в аудит-логе.
 */
struct Judgement {
    1: required Resolution resolution
}

exception RulesetNotFound {}
exception InvalidRuleset {}

/**
 * Переданный контекст не может быть обработан.
 * Подробности этой ошибки можно увидеть в аудит-логе.
 */
exception InvalidContext {}

service Arbiter {

    Judgement Judge (1: RulesetID ruleset, 2: Context ctx) throws (
        1: RulesetNotFound ex1
        2: InvalidRuleset ex2
        3: InvalidContext ex3
    )

}
