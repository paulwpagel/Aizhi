# To change this template, choose Tools | Templates
# and open the template in the editor.

module Admin::BasicAdmin

  def index
    elements = send_message_to_this_model(:all, :order => "created_at DESC")
    eval "@#{model_name.tableize} = elements"
  end

  def edit
    element = send_message_to_this_model(:find, params[:id])
    eval "@#{model_name} = element"
    load_associated_instances
  end

  def update
    element = send_message_to_this_model(:find, params[:id])
    eval "@#{model_name} = element"
    set_associated_instances_to_model(element)
    if element.update_attributes(params[model_name.to_sym])
      flash[:green] = "#{model_class_name.titleize} has been updated successfully"
      index_redirect
    else
      load_associated_instances
      render :edit
    end
  end

  def destroy
    send_message_to_this_model(:delete, params[:id])
    flash[:green] = "#{model_class_name.titleize} has been deleted successfully"
    index_redirect
  end

  def new
    load_associated_instances
  end

  def create
    element = send_message_to_this_model(:new, params[model_name.to_sym])
    eval "@#{model_name} = element"
    set_associated_instances_to_model(element)
    if (element.save)
      flash[:green] = success_create_message(element)
      execute_post_create_actions(element)
      index_redirect
    else
      load_associated_instances
      render :action => "new"
    end
  end

  protected

  def index_redirect
    redirect_to :action => :index
  end
  
  def success_create_message(element)
    "#{model_class_name.titleize} has been created successfully"
  end

  def execute_post_create_actions(element)
    # Override this message to add any post create actions
  end

  private

  def send_message_to_this_model(message_name, args)
    return send_message_to_a_model(model_class_name, message_name, args)
  end

  def send_message_to_a_model(model_name, message_name, args)
    return Kernel.const_get(model_name).send(message_name, args)
  end

  def model_class_name
    model_name.camelize
  end
  
  def model_name
    self.class.controller_name.singularize
  end

  def load_associated_instances
    do_with_associations { |association|
      elements = send_message_to_a_model(association.class_name, :find, :all)
      eval "@#{association.class_name.tableize} = elements"
    }
  end

  def set_associated_instances_to_model(element)
    do_with_associations { |association|
      association_id_param = params[association.class_name.underscore.to_sym][:id]
      association_instance = send_message_to_a_model(association.class_name, :find, association_id_param) unless association_id_param.blank?
      element.send("#{association.class_name.underscore}=", association_instance)
    }
  end

  def do_with_associations(&block)
    associations = send_message_to_this_model(:reflect_on_all_associations, :belongs_to)
    associations.each { |association|
      block.call(association)
    }
  end

end
