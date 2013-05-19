class StatDomain < ActiveRecord::Base
  def compute_averages
    self.points_avg = self.points / self.total
    self.points_avg_seo = 0
    if self.total_seo > 0
      self.points_avg_seo = self.points / self.total_seo
    end
  end
end
