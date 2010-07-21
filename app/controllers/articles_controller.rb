class ArticlesController < ApplicationController
  
  def index
    @articles = Article.find(:all)
  end
  
  def download_article
    @article = Article.find(params[:id])
    download_file(@article.article)
  end
  
end
