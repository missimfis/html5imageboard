class ImageThreadsController < ApplicationController
  # GET /image_threads
  # GET /image_threads.xml
  def index
    @image_thread = ImageThread.new
    @image_threads = ImageThread.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @image_threads }
    end
  end

  # GET /image_threads/1
  # GET /image_threads/1.xml
  def show
    @image_thread = ImageThread.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @image_thread }
    end
  end

  # GET /image_threads/1/edit
  def edit
    @image_thread = ImageThread.find(params[:id])
  end

  # POST /image_threads
  # POST /image_threads.xml
  def create
    @image_thread = ImageThread.new(params[:image_thread])

    respond_to do |format|
      if @image_thread.save
        format.html { redirect_to(@image_thread, :notice => 'Image thread was successfully created. Start adding a post...') }
        format.xml  { render :xml => @image_thread, :status => :created, :location => @image_thread }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @image_thread.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /image_threads/1
  # PUT /image_threads/1.xml
  def update
    @image_thread = ImageThread.find(params[:id])

    respond_to do |format|
      if @image_thread.update_attributes(params[:image_thread])
        format.html { redirect_to(@image_thread, :notice => 'Image thread was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image_thread.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /image_threads/1
  # DELETE /image_threads/1.xml
  def destroy
    @image_thread = ImageThread.find(params[:id])
    @image_thread.destroy

    respond_to do |format|
      format.html { redirect_to(image_threads_url) }
      format.xml  { head :ok }
    end
  end
end
