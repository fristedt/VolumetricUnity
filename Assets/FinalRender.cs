using UnityEngine;
using System.Collections;

public class FinalRender : MonoBehaviour {
    [SerializeField]
    private Texture source;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        RenderTexture tmp = null;
        Graphics.Blit(source, tmp);
	}
}
