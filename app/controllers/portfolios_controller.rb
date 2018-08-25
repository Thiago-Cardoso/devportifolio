class PortfoliosController < ApplicationController
 
  def index
      authorize(Portfolio)
      @portfolios = policy_scope(Portfolio)
  end
    
end