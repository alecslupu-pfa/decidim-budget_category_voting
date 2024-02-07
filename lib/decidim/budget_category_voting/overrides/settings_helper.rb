# frozen_string_literal: true

module Decidim::BudgetCategoryVoting::Overrides::SettingsHelper

  def settings_attribute_input(form, attribute, name, i18n_scope, options = {})
    return super unless %w(vote_category_voting).include?(name.to_s) && attribute.type.to_sym == :array

    return content_tag(:div, class: "#{name}_container") do
      render :partial => "decidim/budget_category_voting/admin/settings/vote_category_voting", :locals => { form: form,
                                                                                                            attribute: attribute,
                                                                                                            name: name,
                                                                                                            i18n_scope: i18n_scope,
                                                                                                            options: options
      }
    end
  end


end
