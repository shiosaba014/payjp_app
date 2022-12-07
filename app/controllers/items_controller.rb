class ItemsController < ApplicationController
  before_action :find_item, only: :order
  def index
    @items = Item.all
  end

  def order
    redirect_to new_card_path and return unless current_user.card.present?

    Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # 環境変数を読み込む
    customer_token = current_user.card.customer_token # ログインしているユーザーの顧客トークンを定義
    Payjp::Charge.create(
      amount: @item.price, # 商品の値段
      customer: customer_token, # 顧客のトークン
      currency: 'jpy' # 通貨の種類（日本円）
    )
    ItemOrder.create(item_id: params[:id])

    redirect_to root_path
  end

  private

  def find_item
    @item = Item.find(params[:id])
  end
end
