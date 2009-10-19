module	Trant #:nodoc:
	module	Acts #:nodoc:
		# Allows ActiveRecord models to be specified as completed.
		#
		# Also provides named scopes for completed and uncompleted finds.
		#
		#   class Post  ActiveRecord::Base
		#     acts_as_completed
		#   end
		#
		#   Task.completed
		#   # SELECT * FROM tasks WHERE tasks.completed_at IS NOT NULL
		#
		#   Task.uncompleted
		#   # SELECT * FROM tasks WHERE tasks.completed_at IS NULL
		#
		#   @task.complete!
		#   # UPDATE tasks SET completed_at = '2008-07-08 15:58:34' WHERE id = 1
		#
		#   @task.uncomplete!
		#   # UPDATE tasks SET completed_at = NULL WHERE id = 1
		#
		#   @task.completed?
		#   # Return true if the task is completed, false if not
		#
		
		module	Completed
			def self.included(base)
				base.extend(ClassMethods)
			end
			
			module ClassMethods
				def acts_as_completed
					include InstanceMethods
				end
			end
			
			module InstanceMethods
				def self.included(base)
					base.named_scope :completed, :conditions => "#{base.table_name}.completed_at IS NOT NULL"
					base.named_scope :uncompleted, :conditions => "#{base.table_name}.completed_at IS NULL"
				end
	
				def complete!
					update_attribute :completed_at, Time.now
				end
				
				def uncomplete!
					update_attribute :completed_at, nil
				end
	
				def completed?
					completed_at.nil? ? false : true
				end
			end
		end
	end
end