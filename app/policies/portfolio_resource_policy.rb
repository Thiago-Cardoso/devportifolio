class PortfolioResourcePolicy < ApplicationPolicy
  def index?
    permitted_action?
  end
end
