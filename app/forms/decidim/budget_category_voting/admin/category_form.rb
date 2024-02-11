# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Admin
      class CategoryForm < Form
        include TranslatableAttributes

        translatable_attribute :name, String

        attribute :value, Integer, default: 0
        attribute :position, Integer
        attribute :color, String
        attribute :deleted, Boolean, default: false

        validates :value, presence: true, numericality: true, unless: :deleted

        def to_param
          return id if id.present?

          "category-id"
        end
      end
    end
  end
end
