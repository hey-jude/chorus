PostgresLikeConnection.class_eval do
  def visualization_sql_generator
    Visualization::SqlGenerator.new(:date_trunc_method => :date_trunc).extend(Visualization::PgLikeSql)
  end
end
