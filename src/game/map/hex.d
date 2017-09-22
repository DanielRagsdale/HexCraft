class Hex
{
	ushort id;
	string identifier;

	public this(ushort id, string str)
	{
		this.id = id;
		this.identifier = str;
	}

	/**
	 * Is this block a solid block, similar to dirt or stone
	 **/
	public bool IsSolidHex()
	{
		return true;
	}
	
	/**
	 * Get the texture ID based upon the face;
	 **/
	public ushort GetTexture(int face)
	{
		if(face == 7)
			return 0;

		return id;
	}
}
