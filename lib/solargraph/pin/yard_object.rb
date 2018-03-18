module Solargraph
  module Pin
    class YardObject < Base
      # @return [YARD::CodeObjects::Base]
      attr_reader :code_object

      def initialize code_object, location
        # (c.to_s.split('::').last, detail: c.to_s, kind: kind, docstring: c.docstring, return_type: return_type, location: object_location(c))
        @code_object = code_object
        @location = location
      end

      def name
        # @name ||= code_object.to_s.split('::').last
        @name ||= code_object.name.to_s
      end

      def kind
        # @todo Figure out the kind
        Solargraph::LanguageServer::CompletionItemKinds::METHOD if code_object.kind_of?(YARD::CodeObjects::MethodObject)
      end

      def docstring
        code_object.docstring
      end

      def return_type
        # @todo Get the return type
        if @return_type.nil?
          if Solargraph::CoreFills::CUSTOM_RETURN_TYPES.has_key?(path)
            @return_type = Solargraph::CoreFills::CUSTOM_RETURN_TYPES[path]
          else
            return nil if docstring.nil?
            tags = docstring.tags(:return)
            if tags.empty?
              overload = docstring.tag(:overload)
              return nil if overload.nil?
              tags = overload.tags(:return)
            end
            return nil if tags.empty?
            return nil if tags[0].types.nil?
            @return_type = tags[0].types[0]
          end
        end
        @return_type
      end

      def location
        # @todo Get the location
        @location
      end

      def path
        code_object.path
      end
      
      def namespace
        # @todo Is this right?
        code_object.namespace.to_s
      end
    end
  end
end
