class ChangeRemindersEngineToInnodb < ActiveRecord::Migration[8.0]
  def up
    execute "ALTER TABLE reminders ENGINE=InnoDB"
  end

  def down
    execute "ALTER TABLE reminders ENGINE=MyISAM"
  end
end
