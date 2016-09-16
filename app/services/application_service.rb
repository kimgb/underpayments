class ApplicationService
  class Response
    attr_reader :data, :message
    
    def initialize(data:, message:)
      @data, @message = data, message
    end
    
    def success?
      raise NotImplementedError
    end
  end

  class Success < Response
    def success?
      true
    end
  end

  class Error < Response
    def success?
      false
    end
  end
end
