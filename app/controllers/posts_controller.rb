class PostsController < ApplicationController

  def index
    @ticket = Ticket.all.order(created_at: :desc)
    @posts=Post.left_joins(:tickets).group(:id).select("posts.id,posts.content,COUNT(tickets.id) AS tickets_count").where("content like ?","%#{params[:content]}%").order(tickets_count: :desc)
    @posts_new=Post.all.order(created_at: :desc).limit(3)
  end

  def show
    @post=Post.find_by(id:params[:id])
    @post_count=Ticket.where(post_id:params[:id]).count
  end

  def new
    @post=Post.new
  end

  def create
    sleep(4)
    @post = Post.new(content: params[:content])
    if @post.save
      flash[:notice]="商品を登録しました"
      redirect_to("/posts/index")
    else
      flash[:notice]="すでに登録されています"
      redirect_to("/posts/new")
    end
  end


  def sending
    sleep(1)
    @post=Post.find_by(id: params[:id])
    @ticket_id=rand(1000000)
    while Ticket.exists?(ticket_id:@ticket_id)
      @ticket_id=rand(1000000)
    end  
    @preticket=Preticket.new(ticket_id:@ticket_id,phonenumber:params[:phonenumber])
    if @preticket.save
      redirect_to("/posts/#{@post.id}/#{@preticket.id}/0/check")
      flash[:notice]="SMSを送信しました"

      account_sid = 'ACc78f79ace01d40dbe374408c0205431c'
      auth_token = '03688ba5b62fad9c633a512b13e55c01'
      client = Twilio::REST::Client.new(account_sid, auth_token)
      countly_number="+81#{params[:phonenumber].to_s[1,10]}"
      client.api.account.messages.create(
        from: '+14152148742',
        to: countly_number,
        body: "Tenba×Iya\n
        チケットID:#{@preticket.ticket_id}")
        #確認画面URL:https://tenba-iya.herokuapp.com/posts/#{@post.id}/#{@preticket.id}/#{@preticket.ticket_id}/check"
      #)
      

      #account_sid = 'ACc78f79ace01d40dbe374408c0205431c'
      #auth_token = '03688ba5b62fad9c633a512b13e55c01'
      #client = Twilio::REST::Client.new(account_sid, auth_token)
      #client.api.account.messages.create(from: '+14152148742',to: "+818064195239",body: "Tenba×Iya")


    else
      redirect_to("/posts/#{@post.id}")
      flash[:notice]="SMSが送れませんでした"
    end






      #countly_number="+81#{params[:phonenumber].to_s[1,10]}"
      #client = Twilio::REST::Client.new
      #client.api.account.messages.create(
      #  from: Rails.application.credentials.twilio[:TWILIO_PHONE_NUMBER],
      #  to: countly_number,
      #  body: "Tenba×Iya\n
      #  チケットID:#{@preticket.ticket_id}\n
      #  確認画面URL:https://tenba-iya.herokuapp.com/posts/#{@post.id}/#{@preticket.id}/#{@preticket.ticket_id}/check"
      #)

      #client.api.account.messages.create(from: Rails.application.credentials.twilio[:TWILIO_PHONE_NUMBER],to: "+818064195239",body: "Hello World!")

      #チケットID、電話番号


  end

  def check
    sleep(1)
    if @preticket=Preticket.find_by(id:params[:preticket_id])
      @post=Post.find_by(id: params[:id])
      if params[:preticket_ticket_id]!="0"
        @ticekt_ticket_id=params[:preticket_ticket_id]
      end
    else
      flash[:notice]="アクセスできません"
      redirect_to("/posts/index")
    end
  end

  def input
    sleep(1)
    @preticket=Preticket.find_by(id:params[:preticket_id])
    if params[:ticket_id]==@preticket.ticket_id
    @ticket=Ticket.new(post_id:params[:id],phonenumber: params[:phonenumber],ticket_id:params[:ticket_id])
      if @ticket.save
        redirect_to("/posts/#{@ticket.id}/#{@ticket.ticket_id}/ticket")
        flash[:notice]="チケットが発行されました"
      else
        @ticket=Ticket.find_by(ticket_id:@preticket.ticket_id)
        redirect_to("/posts/#{@ticket.id}/#{@ticket.ticket_id}/ticket")
        flash[:notice]="チケットがすでに発行されています。"
      end
    else
      redirect_to("/posts/#{params[:id]}/#{params[:preticket_id]}/0/check")
      flash[:notice]="チケットIDが違います"
    end
  end

  def ticket
    sleep(1)
    if @ticket=Ticket.find_by(id:params[:id],ticket_id:params[:ticket_id])
      @post=Post.find_by(id: @ticket.post_id)
      @count_all=Ticket.where(post_id:@ticket.post_id,phonenumber:@ticket.phonenumber).count
      @month=Date.today << 1
      @day=Date.today
      @count_month=Ticket.where(post_id:@ticket.post_id,phonenumber:@ticket.phonenumber).where('created_at >= ?', @month).count
      @count_day=Ticket.where(post_id:@ticket.post_id,phonenumber:@ticket.phonenumber).where('created_at >= ?', @day).count
      @post_count=Ticket.where(post_id:@ticket.post_id).count
    else
      flash[:notice]="チケットIDが違います"
      redirect_to("/posts/index")
    end
  end

  def used
    sleep(1)
    @ticket=Ticket.find_by(id:params[:id],ticket_id:params[:ticket_id])
    @ticket.used=1
    @ticket.save
    @post=Post.find_by(id: @ticket.post_id)
    flash[:notice]="チケットを使用しました"
    redirect_to("/posts/#{@ticket.id}/#{@ticket.ticket_id}/ticket")
  end

  def find
    @post=Post.new
  end

  def findticket
    sleep(3)
    if @ticket=Ticket.find_by(ticket_id:params[:ticket_id])
      flash[:notice]="チケットを検索しました"
      redirect_to("/posts/#{@ticket.id}/#{@ticket.ticket_id}/ticket")
    else
      flash[:notice]="チケットが有りませんでした"
      redirect_to("/posts/find")
    end
  end
  

end
