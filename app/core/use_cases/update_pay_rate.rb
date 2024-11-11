module UseCases
  class UpdatePayRate
    def initialize(repository)
      @repository = repository
    end

    def execute(id:, params:)
      @repository.update!(id, params)
    rescue Repositories::Errors::RecordNotFound
      raise Errors::PayRateNotFound
    rescue Repositories::Errors::RecordInvalid => e
      raise Errors::PayRateUpdateFailed.new(e.errors)
    rescue StandardError => e
      raise Errors::PayRateUpdateFailed.new(["Unexpected error occurred"])
    end
  end
end