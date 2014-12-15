module HtSms

  class << self

    def test_env(test=nil)
      if test.nil?
        @test ||= defined?(Rails) ? Rails.env.test? : true
      else
        @test = !!test
      end
    end

    def config
      return nil unless defined?(Setting)

      if Emitter == DuanXinBao
        @dxb_config ||= defined?(Setting.duan_xin_bao) ? Setting.duan_xin_bao : nil
      end
    end

  end

end
