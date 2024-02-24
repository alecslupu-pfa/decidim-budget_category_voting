# frozen_string_literal: true
module Decidim::BudgetCategoryVoting::Overrides
  module ProjectsHelper
    def fetch_category_explanation(category_hash)
      category = translated_attribute(Decidim::Category.find_by(id: category_hash["decidim_category_id"])&.name)

      case category_hash["criteria"]
      when "vote_rule_selected_projects_enabled"
        if current_order.minimum_projects_for_category(category_hash).positive? &&
          current_order.minimum_projects_for_category(category_hash) < current_order.maximum_projects_for_category(category_hash)
          t(
            ".category_votings.projects_rule.instruction",
            category: category,
            minimum_number: current_order.minimum_projects_for_category(category_hash),
            maximum_number: current_order.maximum_projects_for_category(category_hash)
          )
        else
          t(".category_votings.projects_rule_maximum_only.instruction",
            category: category,
            maximum_number: current_order.maximum_projects_for_category(category_hash)
          )
        end
      when "vote_rule_minimum_budget_projects_enabled"
        t(".category_votings.minimum_projects_rule.instruction",
          category: category,
          minimum_number: current_order.minimum_projects_for_category(category_hash)
        )
      else
        t(".category_votings.vote_threshold_percent_rule.instruction",
          category: category,
          minimum_budget: budget_to_currency(current_order.minimum_projects_for_category(category_hash))
        )
      end
    end

    def fetch_category_description(category_hash)
      category = translated_attribute(Decidim::Category.find_by(id: category_hash["decidim_category_id"])&.name)
      case category_hash["criteria"]
      when "vote_rule_selected_projects_enabled"
        if current_order.minimum_projects_for_category(category_hash).positive? &&
          current_order.minimum_projects_for_category(category_hash) < current_order.maximum_projects_for_category(category_hash)
          t(
            ".category_votings.projects_rule.description",
            category: category,
            minimum_number: current_order.minimum_projects_for_category(category_hash),
            maximum_number: current_order.maximum_projects_for_category(category_hash)
          )
        else
          t(".category_votings.projects_rule_maximum_only.description",
            category: category,
            maximum_number: current_order.maximum_projects_for_category(category_hash)
          )
        end
      when "vote_rule_minimum_budget_projects_enabled"
        t(".category_votings.minimum_projects_rule.description",
          category: category,
          minimum_number: current_order.minimum_projects_for_category(category_hash)
        )
      else
        t(".category_votings.vote_threshold_percent_rule.description",
          category: category,
          minimum_budget: budget_to_currency(current_order.minimum_projects_for_category(category_hash))
        )
      end
    end

    def current_rule_explanation
      return unless current_order

      if current_order.category_voting_rule?
        current_order.budget.settings.vote_category_voting.map do |category|
          fetch_category_explanation(category)
        end.join
      elsif current_order.projects_rule?
        if current_order.minimum_projects.positive? && current_order.minimum_projects < current_order.maximum_projects
          t(
            ".projects_rule.instruction",
            minimum_number: current_order.minimum_projects,
            maximum_number: current_order.maximum_projects
          )
        else
          t(".projects_rule_maximum_only.instruction", maximum_number: current_order.maximum_projects)
        end
      elsif current_order.minimum_projects_rule?
        t(".minimum_projects_rule.instruction", minimum_number: current_order.minimum_projects)
      else
        t(".vote_threshold_percent_rule.instruction", minimum_budget: budget_to_currency(current_order.minimum_budget))
      end
    end

    def current_rule_description
      return unless current_order

      if current_order.category_voting_rule?
        current_order.budget.settings.vote_category_voting.map do |category|
          fetch_category_description(category)
        end.join
      elsif current_order.projects_rule?
        if current_order.minimum_projects.positive? && current_order.minimum_projects < current_order.maximum_projects
          t(
            ".projects_rule.description",
            minimum_number: current_order.minimum_projects,
            maximum_number: current_order.maximum_projects
          )
        else
          t(".projects_rule_maximum_only.description", maximum_number: current_order.maximum_projects)
        end
      elsif current_order.minimum_projects_rule?
        t(".minimum_projects_rule.description", minimum_number: current_order.minimum_projects)
      else
        t(".vote_threshold_percent_rule.description", minimum_budget: budget_to_currency(current_order.minimum_budget))
      end
    end

  end
end
