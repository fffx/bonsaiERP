# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class AccountLedgersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_account_ledger, :only => [:show, :conciliate, :destroy, :new]
 
  # GET /account_ledger 
  def index
    @account_ledgers = AccountLedger.org.where(:account_id => params[:id]).order("date DESC")
  end

  # GET /account_ledgers/:id
  def show
  end

  def new
  end

  # PUT /account_ledgers/:i.more 
  def conciliate
    if @account_ledger.conciliate_account
      flash[:notice] = "Se ha conciliado exitosamente la transacción"
    else
      flash[:error] = @account_ledger.errors[:base].join(", ")
    end
    redirect_to @account_ledger  end

  # POST /account_ledgers
  def create
    @account_ledger = AccountLedger.new(params[:account_ledger])

    if @account_ledger.save
      flash[:notice] = "Se ha creado exitosamente la transacción"
      redirect_to @account_ledger.account
    else
      render :action => 'new'
    end
  end

  # DELETE /account_ledgers/:id
  def destroy
    @account_ledger.destroy
    redirect_ajax @account_ledger
  end

  # GET /account_ledgers/:id/new_transference
  def new_transference
    @account             = Account.org.find(params[:id])
    @account_ledger      = @account.account_ledgers.build
    session[:account_id] = @account.id
  end

  # POST /account_ledgers/:id/transference
  def transference
    @account = Account.org.find(params[:id])
    params[:account_id] = @account.id
    @account_ledger     = @account.account_ledgers.build(params[:account_ledger])

    if @account_ledger.create_transference
      flash[:notice] = "Se ha realizado exitosamente la transferencia entre cuentas"
      redirect_to @account
    else
      render :action => 'new_transference'
    end
  end


private
  def set_account_ledger
    @account_ledger = params[:id].present? ? AccountLedger.org.find(params[:id]) : AccountLedger.new(:account_id => params[:account_id], :income => params[:income])
  end

end
