% Matin Mobini: 300283854
% Michael Massaad: 300293612

% dataset(DirectoryName)
% this is where the image dataset is located, please verify the location of dataset when running program
dataset('/Users/michaelmassaad/Documents/SECOND/CSI2120/ProjectDeliverables/CSI-2120-Programming-Paradigms/CSI2120ProjectPart4/imageDataset2_15_20').

% directory_textfiles(DirectoryName, ListOfTextfiles)
% produces the list of text files in a directory
directory_textfiles(D,Textfiles):- directory_files(D,Files), include(isTextFile, Files, Textfiles).


isTextFile(Filename):-string_concat(_,'.txt',Filename).
% read_hist_file(Filename,ListOfNumbers)
% reads a histogram file and produces a list of numbers (bin values)
read_hist_file(Filename,Numbers):- open(Filename,read,Stream),read_line_to_string(Stream,_),
                                   read_line_to_string(Stream,String), close(Stream),
								   atomic_list_concat(List, ' ', String),atoms_numbers(List,Numbers).
								   
% similarity_search(QueryFile, SimilarImageList)
% returns the list of images similar to the query image
% similar images are specified as (ImageName, SimilarityScore)
% predicate dataset/1 provides the location of the image set
similarity_search(QueryFile,SimilarList) :- dataset(D), directory_textfiles(D,TxtFiles),
                                            similarity_search(QueryFile,D,TxtFiles,SimilarList).
											
% similarity_search(QueryFile, DatasetDirectory, HistoFileList, SimilarImageList)
similarity_search(QueryFile,DatasetDirectory, DatasetFiles,Best):- read_hist_file(QueryFile,QueryHisto), 
                                            compare_histograms(QueryHisto, DatasetDirectory, DatasetFiles, Scores), 
                                            sort(2,@>,Scores,Sorted),take(Sorted,5,Best).

% compare_histograms(QueryHisto, DatasetDirectory, DatasetFiles, Scores)
% compares a query histogram with a list of histogram files 
compare_histograms(_, _, [], []). % base case, when there is no more histogram files for comparison
compare_histograms(QueryHist, DatasetDirectory, [File|RestFiles], [(File, SimilarityScore)|RestScores]):-
    atomic_list_concat([DatasetDirectory, '/', File], FullPath), % getting the path of the dataset histogram that we want to compare
    read_hist_file(FullPath, DatasetHist), % Retrieving the histogram from the file
    histogram_intersection(QueryHist, DatasetHist, SimilarityScore), % computing the intersection which will then be added to the resulting list of pairs
    compare_histograms(QueryHist, DatasetDirectory, RestFiles, RestScores). % recursive call for the comparison of the next dataset file with the query

% totalPix(Hist, Total)
% computes the total amount of pixels in a histogram
totalPix([], 0). % base case, when we have computed the sum of all the buckets in the histogram, we return the result
totalPix([Count|Rest], Total):-
    totalPix(Rest, RestTotal),
    Total is Count + RestTotal.

% normalizeHist(Hist,TotalPix, Norm)
% Computes and returns the normalized histogram
normalizeHist([], _, []). % base case, when we have normalized all the buckets in the histogram
normalizeHist([H|T], TotalPix, [NormalizedVal|NormalizedRest]):-
    NormalizedVal is H/TotalPix,
    normalizeHist(T, TotalPix, NormalizedRest).


% histogram_intersection(Histogram1, Histogram2, Score)
% compute the intersection similarity score between two histograms
% Score is between 0.0 and 1.0 (1.0 for identical histograms)
histogram_intersection(H1,H2,S):- 
    totalPix(H1, Total1),
    totalPix(H2, Total2),
    normalizeHist(H1, Total1, Normalized1),
    normalizeHist(H2, Total2, Normalized2),
    intersection_val(Normalized1, Normalized2, S).

% intersection_val(NH1, NH2, Val)
% calculates the value of the intersection of both normalized histograms
intersection_val([], [], 0). % base case, when both lists are empty, we have compared all the buckets of the normalized histograms, we assume that both are of the same length/size
intersection_val([NH1|NT1], [NH2|NT2], Score):-
    Min is min(NH1, NH2),
    intersection_val(NT1, NT2, RestScore),
    Score is Min + RestScore.

% take(List,K,KList)
% extracts the K first items in a list
take(Src,N,L) :- findall(E, (nth1(I,Src,E), I =< N), L).

% atoms_numbers(ListOfAtoms,ListOfNumbers)
% converts a list of atoms into a list of numbers
atoms_numbers([],[]).
atoms_numbers([X|L],[Y|T]):- atom_number(X,Y), atoms_numbers(L,T).
atoms_numbers([X|L],T):- \+atom_number(X,_), atoms_numbers(L,T).