module NodeRegistrationsHelper

  ## Helper method for using RegFormBuilder
  class RegFormBuilder < ActionView::Helpers::FormBuilder
    def text_field(name, options = {})
      options.reverse_merge! ({ :readonly =>  !object.can_change?,
                                   :class => 'form_field',})
      super(name,options)
    end
  
    def select(method, choices, options = {}, html_options = {})
      html_options.reverse_merge! ({ :class => 'form_field'})
      super(method, choices,options,html_options)
    end
  
    def node_field(node_options)
      if(object.can_change_node?)
        select :node_id, node_options
      else
        @template.content_tag(:span, object.node) 
      end
    end
    
    def text_area(name, options = {})
      options.reverse_merge! ({ :class => 'form_field'})
      super(name, options)
    end
    
    def submit(name)
      super(name) if  object.can_change?
    end
  end
end
