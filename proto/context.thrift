namespace java com.rbkmoney.bouncer.ctx
namespace erlang bctx

enum ContextFragmentType {
    /**
     * Используется `context_v1.ContextFragment` в качестве модели контекста.
     * Содержимое представлено согласно thrift strict binary encoding.
     */
    v1_thrift_binary
}

/**
 * Модель непрозрачного для клиентов фрагмента контекста для принятия решений.
 *
 * Непрозрачность здесь введена с целью минимизировать количество сервисов,
 * которые необходимо будет обновлять при изменении модели контекста, например
 * в случае добавления новых атрибутов.
 */
struct ContextFragment {
    1: required ContextFragmentType type
    2: optional binary content
}
