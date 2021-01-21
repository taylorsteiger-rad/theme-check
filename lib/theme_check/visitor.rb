# frozen_string_literal: true
module ThemeCheck
  class Visitor
    def initialize(checks)
      @checks = checks
      @disabled_checks = DisabledChecks.new
    end

    def visit_template(template)
      visit(Node.new(template.root, nil, template))
    rescue Liquid::Error => exception
      exception.template_name = template.name
      call_checks(:on_error, exception)
    end

    def visit(node)
      call_checks(:on_node, node)
      call_checks(:on_tag, node) if node.tag?
      call_checks(:"on_#{node.type_name}", node)
      node.children.each { |child| visit(child) }
      unless node.literal?
        call_checks(:"after_#{node.type_name}", node)
        call_checks(:after_tag, node) if node.tag?
        call_checks(:after_node, node)
      end

      @disabled_checks.update(node) if node.comment?
    end

    private

    def visit_children(node)
      node.children.each { |child| visit(child) }
    end

    def call_checks(method, *args)
      checks.call(method, *args)
    end

    def checks
      return @checks unless @disabled_checks.any?

      return Checks.new if @disabled_checks.all_disabled?

      @checks.except_disabled(@disabled_checks)
    end
  end
end
