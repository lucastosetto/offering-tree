module UseCases
  class CreatePayRate
    def initialize(repository)
      @repository = repository
    end

    def execute(params:)
      @repository.create!(params)
    rescue Repositories::Errors::RecordInvalid => e
      raise Errors::PayRateCreationFailed.new(e.errors)
    rescue StandardError => e
      raise Errors::PayRateCreationFailed.new(["Unexpected error occurred"])
    end
  end
end