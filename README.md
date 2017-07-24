# Simple Transaction (Proof of concept)

## Usage

```ruby
module Documents
  class ConfirmTransaction < Transaction
    reduce(lambda(context) {
      { document: Document.find(context[:document_id]) }
    })
    tap AuthorizationOperation.new(DocumentPolicy, :confirm?)
    reduce(lambda(context) {
      { document_params: { status: :confirmed } }
    })
    tap(lambda(context) {
      context[:document].update!(context[:document_params])
    })
    tap HistoryOperation.new
    tap RecalculateStatus.new
  end

  class AuthorizationOperation
    attr_reader :kind, :policy_class

    def initialize(policy_class, kind)
      @policy_class = policy_class
      @kind = kind
    end

    def call(context)
      unless allowed?(*context.values_at(:owner, :document))
        raise Pundit::NotAuthorizedError, 'not allowed to confirm document'
      end
    end

    private def allowed?(owner, target)
      policy_class.new(owner, target).method(kind).call
    end
  end

  class HistoryOperation
    def call(context)
      ActivityLog.create!(
        owner: context[:owner],
        operation_type: context[:operation_type],
        target_id: context[:document_id],
        message: {
          interpolation_data: {},
          meta: context
        }
      )
      context
    end
  end

  class RecalculateStatus
    def call(context)
      entity = context[:document].compliant_entity
      return unless entity.is_a?(Person)
      entity.update!(status: entity.recalculate_status)
    end
  end
end
```
