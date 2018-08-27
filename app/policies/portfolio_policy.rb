class PortfolioPolicy < ApplicationPolicy
  def index?
    true
  end


  def create?
    #record.user == user
    true
  end


  def edit?
    record.user == user
  end


  private

  class Scope < Scope
    def resolve
      user.portfolios
    end
  end
end