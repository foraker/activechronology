require 'active_support'

module ActiveChronology
  module Chronology
    extend ActiveSupport::Concern

    module ClassMethods
      def set_chronology(attribute = :created_at)
        scope 'chronological',         -> { order("#{table_name}.#{attribute}") }
        scope 'reverse_chronological', -> { order("#{table_name}.#{attribute} desc") }
      end

      def scope_by_timestamp(*attributes)
        attributes.each do |attribute|
          name = attribute.to_s.sub(/_(at|on|time|date)$/, '')

          scope "#{name}_after",   single_time_scope(attribute, '>')
          scope "#{name}_before",  single_time_scope(attribute, '<')
          scope "#{name}_between", between_time_scope(attribute)
        end
      end

      private

      def single_time_scope(attribute, base_operator)
        -> (time, options = {}) do
          operator = options[:exclusive] ? base_operator : "#{base_operator}="

          time.present? ? where("#{table_name}.#{attribute} #{operator} ?", time) : all
        end
      end

      def between_time_scope(attribute)
        -> (start_time, end_time, options = {}) do
          if options[:exclusive]
            where(
              "#{table_name}.#{attribute} > ? AND #{table_name}.#{attribute} < ?", start_time, end_time)
          else
            where(attribute => start_time..end_time)
          end
        end
      end
    end
  end
end
