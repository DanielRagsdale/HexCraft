import renderObjectData;

/**
* Gives render functionality to a component
*/
interface IRenderable
{
    /**
    * Return the RenderData object needed to draw this component
	* 
	* This method is called by an separate thread, so Render() 
	* must be valid to call at any moment
    */
	public RenderData Render();
}
