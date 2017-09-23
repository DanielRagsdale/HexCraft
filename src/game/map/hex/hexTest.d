import hex;

class HexTest : Hex
{
	this(ushort id, string str)
	{
		super(id, str); 
	}
	
	/**
	 * Is this block a solid block, similar to dirt or stone
	 **/
	public override bool IsSolidHex()
	{
		return false;
	}

	public override int GetRenderFunction()
	{
		return 1;
	}
}
