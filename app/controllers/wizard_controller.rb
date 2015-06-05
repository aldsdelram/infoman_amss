class WizardController < ApplicationController
  include AdminsHelper
  skip_before_filter :authorize
  layout "wizard"

  def index
    @admin = Admin.new
  end

  def addAdmin
    if request.xhr?
      @admin = Admin.new(params[:admin])
      @image_data = params[:base64]


      file_name = "pic_#{Time.now.strftime("%Y%m%d%H%M%S")}.png"
      @admin.image_name = "upload_images/admins/"+file_name

      respond_to do |format|
        data = [];
        if @admin.save
          upload_image(file_name, params[:base64])
          data << {"ok"=> true}
        else
          data << {"ok"=> false}
          data << @admin.errors
          data << {"errors" => @admin.errors.count}
        end

        format.js { render :json => data.to_json}
      end
    end
  end
end




{
  "auto_complete_commit_on_tab": true,
  "caret_style": "solid",
  "color_scheme": "Packages/Predawn/predawn.tmTheme",
  "draw_white_space": "all",
  "enable_tab_scrolling": false,
  "ensure_newline_at_eof_on_save": true,
  "file_exclude_patterns":
  [
    "*.pyc",
    "*.pyo",
    "*.exe",
    "*.dll",
    "*.obj",
    "*.o",
    "*.a",
    "*.lib",
    "*.so",
    "*.dylib",
    "*.ncb",
    "*.sdf",
    "*.suo",
    "*.pdb",
    "*.idb",
    "*.class",
    "*.psd",
    "*.db",
    "*.beam",
    ".DS_Store",
    ".tags"
  ],
  "findreplace_small": true,
  "folder_exclude_patterns":
  [
    ".svn",
    ".git",
    ".hg",
    "CVS",
    ".sass-cache"
  ],
  "font_size": 9,
  "highlight_line": true,
  "highlight_modified_tabs": true,
  "ignored_packages":
  [
    "Vintage"
  ],
  "rulers":
  [
    80,
    120
  ],
  "scroll_past_end": false,
  "sidebar_xsmall": true,
  "tab_size": 2,
  "tabs_medium": true,
  "theme": "predawn.sublime-theme",
  "translate_tabs_to_spaces": true,
  "trim_trailing_white_space_on_save": true,
  "wide_caret": true,
  "word_separators": "./\\()\"'-:,.;<>~@#$%^&*|+=[]{}`~",
  "word_wrap": false,
  "caret_style": "phase",
  "font_face": "Source Code Pro"
}
