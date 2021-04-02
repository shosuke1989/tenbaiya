class PostsController < ApplicationController

  def index
    @ticket = Ticket.all.order(created_at: :desc)
    @posts=Post.left_joins(:tickets).group(:content).select("posts.content,posts.id AS id,COUNT(`tickets`.`id`) AS tickets_count").where('content like ?',"%#{params[:content]}%").order(tickets_count: :desc)
    #@posts=Post.left_joins(:buys).where('created_at like ?',"%#{params[:content]}%")
    #@posts=Post.where("created_at like ?","2021-03-31%")
    #@posts=Post.all.where('content like ?',"%#{params[:content]}%")
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
    @post = Post.new(content: params[:content])
    if @post.save
      flash[:notice]="投稿を作成しました"
      redirect_to("/posts/index")
    else
      render("posts/new")
    end
  end

  def sending
    @post=Post.find_by(id: params[:id])
    if params[:phonenumber]==""
      redirect_to("/posts/#{@post.id}")
    else
      @phonenumber=params[:phonenumber]
      @ticket_id=rand(1000000)
      while Ticket.exists?(ticket_id:@ticket_id)
        @ticket_id=rand(1000000)
      end  
      @preticket=Preticket.new(ticket_id:@ticket_id)
      @preticket.save
      redirect_to("/posts/#{@post.id}/#{@phonenumber}/#{@preticket.id}/check")
    end
  end

  def check
    @ticket_id=Preticket.find_by(id:params[:ticket_id])
    @post=Post.find_by(id: params[:id])
    @phonenumber=params[:phonenumber]
  end

  def input
    if params[:ticket_id]==params[:ticket_id]
    @post=Post.find_by(id: params[:id])
    @ticket=Ticket.new(post_id:params[:id],phonenumber: params[:phonenumber],ticket_id:params[:ticket_id])
      if @ticket.save
        redirect_to("/posts/#{@ticket.id}/ticket")
      else
        #すでに登録されています。
      end
    else
      #IDが違います
    end
  end

  def ticket
    @ticket=Ticket.find_by(id:params[:id])
    @post=Post.find_by(id: @ticket.post_id)
    @count_all=Ticket.where(post_id:@ticket.post_id,phonenumber:@ticket.phonenumber).count
    @month=Date.today << 1
    @day=Date.today
    @count_month=Ticket.where(post_id:@ticket.post_id,phonenumber:@ticket.phonenumber).where('created_at >= ?', @month).count
    @count_day=Ticket.where(post_id:@ticket.post_id,phonenumber:@ticket.phonenumber).where('created_at >= ?', @day).count

  end

  def used
    @ticket=Ticket.find_by(id:params[:id])
    @post=Post.find_by(id: @ticket.post_id)
    @ticket.used=1
    @ticket.save
    redirect_to("/posts/#{@ticket.id}/ticket")
  end

  def find
    @post=Post.new
  end

  def findticket
    #flash[:notice]="投稿を作成しました"

    sleep(3)
    if @ticket=Ticket.find_by(ticket_id:params[:ticket_id])
      redirect_to("/posts/#{@ticket.id}/ticket")
    else
      redirect_to("/posts/find")
    end
  end
  

end
