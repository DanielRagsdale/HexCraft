import renderObjectData;

/**
* Gives render functionality to a component
*/
interface IRenderable
{
    /**
    * Return the RenderData object needed to draw this component
    */
	public RenderData Render();
}