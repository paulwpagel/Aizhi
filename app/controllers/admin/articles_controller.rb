class Admin::ArticlesController < AdminController
  include Admin::BasicAdmin
  def delete
    @article = Article.find(params[:id])
    @article.destroy
    flash[:green] = "Article for '#{@article.title}' has been deleted successfully"
    redirect_to :action => :index
  end
end
