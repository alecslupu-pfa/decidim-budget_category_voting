# frozen_string_literal: true

require "spec_helper"

describe "Orders", type: :system do
  include_context "with a component"
  let(:manifest_name) { "budgets" }

  let(:organization) { create :organization, available_authorizations: %w(dummy_authorization_handler) }
  let!(:user) { create :user, :confirmed, organization: organization }
  let(:project) { projects.first }

  let!(:component) do
    create(:budgets_component,
           :with_minimum_budget_projects,
           manifest: manifest,
           participatory_space: participatory_process,
           vote_minimum_budget_projects_number: 2)
  end
  let(:minimum_to_select) { 3 }
  let(:category) { create(:category, participatory_space: component.participatory_space) }
  let(:category_budget_rules) do
    [
      { position: 0,
        decidim_category_id: category.id,
        vote_minimum_budget_projects_number: minimum_to_select }
    ]
  end
  let(:budget) { create :budget_category_voting, :with_minimum_budget_projects, component: component, category_budget_rules: category_budget_rules }

  context "when the user is not logged in" do
    let!(:projects) { create_list(:project, 1, budget: budget, budget_amount: 25_000_000) }

    it "is given the option to sign in" do
      visit_budget

      within "#project-#{project.id}-item" do
        page.find(".budget-list__action").click
      end

      expect(page).to have_css("#loginModal", visible: :visible)
    end
  end

  context "when the user is logged in" do
    let!(:projects) { create_list(:project, 3, budget: budget, category: category, budget_amount: 25_000_000) }

    before do
      login_as user, scope: :user
    end

    context "when visiting budget" do
      before do
        visit_budget
      end

      context "when voting by minimum projects number" do
        it "displays description messages" do
          within ".budget-summary" do
            expect(page).to have_content("What projects do you think we should allocate budget for? Select at least 3 projects you want and vote according to your preferences to define the budget.")
          end
        end

        it "displays rules" do
          within ".voting-rules" do
            expect(page).to have_content("Select at least 3 projects you want and vote according to your preferences to define the budget.")
          end
        end

        it "displays the category boxes" do
          expect(page).to have_selector(".column.vote_by_category", count: 1)
          within ".column.vote_by_category" do
            expect(page).to have_selector("h3", text: minimum_to_select)
            expect(page).to have_content(translated(category.name))
            expect(page).to have_content("Remaining votes")
          end
        end
      end
    end

    context "and has not a pending order" do
      before do
        visit_budget
      end

      context "when voting by minimum projects number" do
        it "adds a project to the current order" do
          within "#project-#{project.id}-item" do
            page.find(".budget-list__action").click
          end

          expect(page).to have_selector ".budget-list__data--added", count: 1

          expect(page).to have_content "ASSIGNED: €25,000,000"
          expect(page).to have_content "1 project selected"

          within ".budget-summary__selected" do
            expect(page).to have_selector(".budget-summary__selected-item", text: translated(project.title), visible: :hidden)
          end

          within "#order-progress .budget-summary__progressbox" do
            expect(page).to have_content "25%"
            expect(page).to have_selector("button.small:disabled")
          end

          expect(page).to have_selector(".column.vote_by_category", count: 1)
          within ".column.vote_by_category" do
            expect(page).to have_selector("h3", text: minimum_to_select - 1)
            expect(page).to have_content(translated(category.name))
            expect(page).to have_content("Remaining votes")
          end
        end

        it "displays total budget" do
          within ".budget-summary__total" do
            expect(page).to have_content("TOTAL BUDGET €100,000,000")
          end
        end
      end
    end

    context "and has pending order" do
      let!(:order) { create(:order, user: user, budget: budget) }
      let!(:line_item) { create(:line_item, order: order, project: project) }
      let(:minimum_to_select) { 3 }

      context "when the voting rule is set to minimum projects" do
        before do
          order.destroy!
        end

        let!(:order_min) { create(:order, user: user, budget: budget) }

        context "when allows the voting" do
          it "can vote" do
            visit_budget

            projects.each do |project|
              within "#project-#{project.id}-item" do
                page.find(".budget-list__action").click
              end
            end

            within "#order-progress" do
              expect(page).to have_button("Vote", disabled: false)
            end
          end
        end

        context "when prevents voting if the minimum projects are not selected" do
          it "cannot vote" do
            visit_budget

            within "#order-progress" do
              expect(page).to have_button("Vote", disabled: true)
            end
          end

          context "when categoy is mismatched" do
            let(:minimum_to_select) { 5 }
            let(:additional_category) { create(:category, participatory_space: component.participatory_space) }
            let!(:additional_projects) { create_list(:project, 2, budget: budget, category: additional_category, budget_amount: 25_000_000) }

            it "cannot vote" do
              visit_budget

              projects.each do |project|
                within "#project-#{project.id}-item" do
                  page.find(".budget-list__action").click
                end
              end
              additional_projects.each do |project|
                within "#project-#{project.id}-item" do
                  page.find(".budget-list__action").click
                end
              end

              within "#order-progress" do
                expect(page).to have_button("Vote", disabled: true)
              end
            end
          end
        end
      end
    end
  end

  def visit_budget
    page.visit Decidim::EngineRouter.main_proxy(component).budget_projects_path(budget)
  end
end
