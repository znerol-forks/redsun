# encoding: UTF-8
require_dependency 'wiki_page'

# Patches Redmine's User dynamically.
module RedmineRedsun
  module WikiPagePatch
    def self.included(base) # :nodoc:

      base.extend ClassMethods
      base.send(:include, InstanceMethods)

      # Same as typing in the class
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development

        searchable do
          
          # Class Name
          string :class_name, stored: true

          # Project ID
          integer :project_id
          
          # Active?
          boolean :active, stored: true do
            active?
          end
          
          # Page Title
          text :title, :stored => true, :boost => 9 do
            title.scan(/[[:print:]]/).join
          end

          # Content of Page
          text :wiki_content, :stored => true, :boost => 7  do
            content.text.scan(/[[:print:]]/).join
          end

          # Updated at
          time :updated_on, :trie => true

          #  Creator
          integer :author_id, :references => User do
            content.author_id
          end
          
          # Name of Project
          string :project_name, stored: true

        end
     end

    end

    module ClassMethods

    end

    module InstanceMethods
      SORT_FIELDS = ["updated_on", "created_on", "score"]
      SORT_ORDER = [["ASC", "label_ascending"],["DESC", "label_descending"]]
      
      def class_name
        self.class.name
      end
      
      def project_id
        wiki.project_id
      end
      
      def project_name
        project.name if project
      end
      
      def active?
        wiki.project.active?
      end
      
    end

  end
end